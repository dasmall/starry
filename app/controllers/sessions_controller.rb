class SessionsController < ApplicationController
  def create
    auth_data = env['omniauth.auth']
    uid = auth_data.uid

    @user = User.find_by uid: uid

    unless @user
      @user = User.create_new_user(auth_data)
    end
    
    session[:user_id] = @user.id
    redirect_to root_url, notice: "Signed in!"
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end