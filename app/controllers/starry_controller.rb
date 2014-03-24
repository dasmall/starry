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
      @user = User.find_by id: session[:user_id]
      puts ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], @user.to_json
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_API_KEY']
        config.consumer_secret     = ENV['TWITTER_API_SECRET']
        config.access_token        = @user.access_token
        config.access_token_secret = @user.access_token_secret
      end
      puts client.status(447904129692999680).to_json
    end
  end

  def signin
  end

  def signout
  end
end
