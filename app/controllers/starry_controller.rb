class StarryController < ApplicationController
  TWITTER_RESULT_COUNT = 200.freeze
  def index
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
  end

  def get_faves
    unless session[:user_id]
      redirect_to root_url
    else

      @user = User.find_by id: session[:user_id]
      client = setup_twitter_client

      last_id = nil
      favorites = []

      i = 0
      # Grab up to most recent 1000 favorites
      for i in 0..5
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
    end
  end

  def show_faves
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
    @faves = FavoriteTweet.where(:user => @user.id).order(:date_posted => :desc)
  end

  def signin
  end

  def signout
  end

  private

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
      if not last_id_imported.nil?
        # queries with max_id return tweets up to
        # max_id including the max_id tweet.
        # subtract 1 to exclude max_id tweet.
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
        last_id_imported = FavoriteTweet.where(user: session[:user_id]).last.status_id.to_i
        search_options[:since_id] = last_id_imported
      end
    end
    return search_options
  end
end
