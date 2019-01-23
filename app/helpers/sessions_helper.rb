module SessionsHelper
  def authentication
      return if current_user

      redirect_to '/'
  end

  def logged_in
      !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(token: cookies[:token]) if !cookies[:token].blank?
  end
end
