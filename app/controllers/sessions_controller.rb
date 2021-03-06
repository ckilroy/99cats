class SessionsController < ApplicationController
    before_action :redirect_to_index_if_signed_in, except: [:destroy]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name],
      params[:user][:password])

    if @user.nil?
      render :new
    else
      login_user!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    current_user.try(:reset_session_token!)
    # current_user && current_user.reset_session_token!
    session[:token] = nil

    redirect_to new_session_url
  end

end
