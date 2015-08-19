class UsersController < ApplicationController

  def new
    @user = User.new        # so can pre-fill attr, call errors, etc.
    render :new
  end

  def create
    @user = User.new(user_params)
    render json: @user
    # if @user.save
  end

  private

  def user_params
    params.require(:user).permit([:user_name, :password_digest, :session_token])
  end

end
