class UsersController < ApplicationController

  def create

  end
  def index
    @users = User.all
    render json: {code: 200, message: "User all", data: @users}
  end

  def show

  end

  def update

  end

  def destroy

  end

  def edit

  end

  def user_params
    params.permit(:id, :email, :password, :name)
  end
end
