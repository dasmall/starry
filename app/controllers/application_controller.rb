class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def require_session
    if not session[:user_id]
      flash[:warning] = "Please login first."
      redirect_to root_path
    end
  end

  def setup_twitter_client
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @user.access_token
      config.access_token_secret = @user.access_token_secret
    end
  end
end
