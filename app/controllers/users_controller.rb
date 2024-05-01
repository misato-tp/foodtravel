class UsersController < ApplicationController
  def index
  end
  
  def profile
    @user = current_user
  end

  def account
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
    @restaurant = Restaurant.find(params[:id])
  end

  def myrestaurants
    @restaurants = Restaurant.all
    @restaurants = current_user.restaurants
  end
end

private

def user_params
  params.require(:user).permit(:username, :email, :user_id)
end
