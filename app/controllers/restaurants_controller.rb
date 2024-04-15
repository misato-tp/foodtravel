class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_path(@restaurant.id)
    else
      render :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    restaurant = Restaurant.find(params[:id])
    restaurant.update(restaurant_params)
    redirect_to restaurant_path(restaurant.id)
  end

  def destroy
    restaurant = Restaurant.find(params[:id])
    if restaurant.destroy
      redirect_to restaurants_path
    else
      redirect_to restaurants_path
    end
  end
end

private

def restaurant_params
  params.require(:restaurant).permit(:name, :address, :image, :memo)
end
