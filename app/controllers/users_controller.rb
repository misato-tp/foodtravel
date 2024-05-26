class UsersController < ApplicationController
  before_action :authenticate_user!
  def profile
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to users_profile_path
    else
      render users_profile_path
    end
  end

  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:restaurant_id)
    @like_restaurants = Restaurant.find(likes)
  end

  def myrestaurants
    @restaurants = current_user.restaurants
  end

  def myreports
    @reports = current_user.reports
    @restaurants = @reports.map { |report| report.restaurant }.uniq
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :user_id)
  end
end
