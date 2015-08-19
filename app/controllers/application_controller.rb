class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :exception

  helper_method :current_user
  # makes available to views. available to other controllers by default

  def current_user
    return nil if self.session[:session_token].nil?
      # by default, not allowing NULL tokens -- but added security measure
    @user ||= User.find_by(:session_token = self.session[:session_token])
      # QUESTION: should this refer to same @user instance var in SessionsController??
  end

end
