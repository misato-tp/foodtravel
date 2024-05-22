class LikesController < ApplicationController
  before_action :restaurant_params
  def create
    Like.create(user_id: current_user.id, restaurant_id: params[:id])
  end

  def destroy
    Like.find_by(user_id: current_user.id, restaurant_id: params[:id]).destroy
  end

  private

  def restaurant_params
    @restaurant = Restaurant.find(params[:id])
  end
end
