class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    p user_params
    if user.save
      p user.errors.full_messages
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username)
  end
end
