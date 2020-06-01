class SessionsController < ApplicationController
  def new
  end

  def create
    user_session = params[:session]
    user = User.find_by(email: user_session[:email].downcase)
    if user&.authenticate(user_session[:password])
      session[:user_id] = user.id
      redirect_to user, notice:  'Logged in successfully'
    else
      flash.now[:alert] = 'There was something wrong with log in details'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out'
  end
end
