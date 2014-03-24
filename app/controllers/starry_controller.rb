class StarryController < ApplicationController
  def index
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
    end
  end

  def signin
  end

  def signout
  end
end
