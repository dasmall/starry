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
end
