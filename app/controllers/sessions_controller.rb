class SessionsController < ApplicationController
  def new
  end

  def create 
    user = User.find_by(first_name: params[:session][:first_name], last_name: params[:session][:last_name])
    if !user.nil? && user.password == params[:session][:password]
      log_in user
      redirect_to '/'
    else
      flash[:message] = 'Invalid email/password combination'
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to '/'
  end
end
