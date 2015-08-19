class UsersController < ApplicationController
#QUESTION - why would we need a before_action in the UserController?

  def new
    @user = User.new        # so can pre-fill attr, call errors, etc.
    render :new
  end

  def create
    @user = User.new(user_params)
    render json: @user
    # REFACTOR: need to build user registration page
  end

  private

  def user_params
    params.require(:user).permit([:user_name, :password_digest, :session_token])
  end

end
