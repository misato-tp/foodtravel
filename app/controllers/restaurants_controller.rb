class RestaurantsController < ApplicationController
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
    restaurant = Restaurant.new(restaurant_params)
    if restaurant.save
      redirect_to restaurants_path
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
      redirect_to restaurants_path, notice: "削除が完了しました"
    else
      redirect_to restaurants_path, alert: "削除に失敗しました"
    end
  end
end

private

def restaurant_params
  params.require(:restaurant).permit(:name, :address, :image, :memo)
end
