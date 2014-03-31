class SessionsController < ApplicationController
  skip_before_filter :force_facebook

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to :root
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end

