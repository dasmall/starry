class StarryController < ApplicationController
  before_action :require_session
  skip_before_action :require_session, only: [:index]

  TWITTER_RESULT_COUNT = 200.freeze
  def index
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
      @random_favorites = FavoriteTweet.random_favorites @user.id
    end
  end

  def get_faves

    @user = User.find_by id: session[:user_id]
    client = setup_twitter_client

    last_id = nil
    favorites = []

    i = 0
    # Grab up to most recent 1000 favorites
    for i in 0..15
      search_options = setup_search_params(last_id)

      results = client.favorites(search_options)

      new_favorites = get_new_favorites(results)
      
      favorites.concat new_favorites

      # Duplicate favorites returned / No favorites returned.
      # No need to request more.
      if results.empty? or (new_favorites.length <= results.length)
        break
      end

      i += 1
      last_id = results.last.id

    end

    # Reverse order for most recent tweet to be stored last
    # to keep order in which it was given via API
    favorites = favorites.reverse
    favorites.each do |favorite_data|
      FavoriteTweet.create_new_favorite favorite_data, session[:user_id]
    end

    redirect_to action: 'show_faves'
  end

  def show_faves
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
    @faves = FavoriteTweet.where(:user => @user.id).order(:date_posted => :desc)
  end

  private

  def require_session
    if not session[:user_id]
      flash[:warning] = "Please login first."
      redirect_to root_path
    end
  end

  def get_new_favorites(favorites)
    favorites.each_with_index do |fave, i|
      existing_favorite = FavoriteTweet.find_by status_id: fave.id
      if existing_favorite
        # Return only array of new favorites.
        return new_favorites = favorites.slice(0, i)
        break
      end
    end
    return favorites
  end

  def setup_twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @user.access_token
      config.access_token_secret = @user.access_token_secret
    end
  end

  def setup_search_params(last_id_imported=nil)
    search_options = {
      :count => TWITTER_RESULT_COUNT
    }
    case params[:import_type]
    when 'import'
      if last_id_imported.nil?
        # queries with max_id return tweets up to
        # max_id including the max_id tweet.
        # subtract 1 to exclude max_id tweet.
        earliest_fave = FavoriteTweet.where(user: session[:user_id]).order(:date_posted => :asc).limit(1)
        if not earliest_fave.empty?
          last_id_imported = earliest_fave[0].status_id.to_i - 1
          search_options[:max_id] = last_id_imported
        end
      else
        search_options[:max_id] = last_id_imported - 1
      end

    when 'update'
      if not last_id_imported.nil?
        # queries with max_id return tweets up to
        # max_id including the max_id tweet.
        # subtract 1 to exclude max_id tweet.
        search_options[:max_id] = last_id_imported - 1
      else
        # Doesn't work for favorited tweets created prior to since_id
        last_fave = FavoriteTweet.where(user: session[:user_id]).last
        if not last_fave
          last_id_imported = last_fave.status_id.to_i
          search_options[:since_id] = last_id_imported
        end
      end
    end
    return search_options
  end
end
