class StarryController < ApplicationController
  def index
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
  end

  def get_faves
    unless session[:user_id]
      redirect_to root_url
    else
      search_options = {
        :count => 100
      }
      @user = User.find_by id: session[:user_id]
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_API_KEY']
        config.consumer_secret     = ENV['TWITTER_API_SECRET']
        config.access_token        = @user.access_token
        config.access_token_secret = @user.access_token_secret
      end
      most_recent_favorite = FavoriteTweet.where(user: @user.id).order(date_posted: :asc).first
      
      puts most_recent_favorite.to_json

      if most_recent_favorite
        search_options[:max_id] = most_recent_favorite.status_id.to_i - 1
      end

      # TODO query until all favorites retrieved
      # TODO change query to first get most recent tweets, then tweets before
      # the last returned favorite in each batch
      
      user_favorites = client.favorites(search_options)
      user_favorites.each do |favorite_data|
        FavoriteTweet.create_new_favorite favorite_data, session[:user_id]
      end

    end
  end

  def signin
  end

  def signout
  end
end
