class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  helper_method :current_user
  # makes available to views. available to other controllers by default

  def current_user
    return nil if session[:token].nil?
      # by default, not allowing NULL tokens -- but added security measure
    @user ||= User.find_by(session_token: session[:token])
      # QUESTION: should this refer to same @user instance var in SessionsController??
  end

  def login_user!(user)
    user.reset_session_token!           # this is a log_in! method
    session[:token] = user.session_token
  end

  def redirect_to_index_if_signed_in
    redirect_to cats_url if current_user
  end

  def check_cat_ownership
    if params[:controller] == "cats"
      @cat = Cat.find(params[:id])
    elsif params[:controller] == "cat_rental_requests"
      @cat = CatRentalRequest.find(params[:id]).cat
    end

    redirect_to cats_url unless current_user.id == @cat.user_id
  end

end
