class StarryController < ApplicationController
  before_action :require_session
  skip_before_action :require_session, only: [:index]

  def index
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
      @random_favorites = @user.random_favorites
    end
  end

  def get_faves
    @user = User.find_by id: session[:user_id]
    TwitterSyncWorker.new.perform(@user.id, params[:import_type])

    redirect_to action: 'show_faves'
  end

  def show_faves
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
    @faves = @user.favorite_tweets.recent
  end
end
