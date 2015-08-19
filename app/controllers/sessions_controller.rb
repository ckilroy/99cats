class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name],
      params[:user][:password])

    if @user.nil?
      render :new
    else
      @user.reset_session_token!           # this is a log_in! method
      session[:token] = @user.session_token
      redirect_to cats_url
    end
  end

  def destroy
    current_user && current_user.reset_session_token!
      # QUESTION: how to handle this? should reset to nil or regenerate?
    session[:token] = nil

    redirect_to new_session_url
  end

  # def session_params
  #   params.require(:user).permit(:user_name, :password)
  # end
end
