class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_session_timeout

private
  def check_session_timeout
    return unless session[:user_id]

    timeout_period = 24.hours

    if session[:last_seen_at] && session[:last_seen_at] < timeout_period.ago
      reset_session
      redirect_to signin_path, alert: "Your session has expired due to inactivity."
    else
      session[:last_seen_at] = Time.current
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_signin
    unless current_user
      redirect_to signin_path, alert: "You must be logged in!"
    end
  end

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Anauthorized access!"
    end
  end

  def current_user_admin?
    current_user && current_user.admin?
  end
  helper_method :current_user_admin?
end
