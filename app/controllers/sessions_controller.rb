class SessionsController < ApplicationController
  def create
    auth_data = env['omniauth.auth']
    uid = auth_data.uid

    @user = User.find_by uid: uid

    unless @user
      @user = User.create_new_user(auth_data)
      redirect_to favorites_mod_url(import_type: 'import')
    else
      redirect_to root_url
    end
    session[:user_id] = @user.id
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You have been logged out."
  end
end