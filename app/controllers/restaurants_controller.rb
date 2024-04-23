class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  def index
    @restaurants = Restaurant.all
    @country = @restaurant.country
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @countries = @restaurant.country
    @report = Report.new
    @restaurant_reports = @restaurant.reports.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_path(@restaurant.id)
    else
      render :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    @country = @restaurant.country
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant.id)
    else
      render :edit
    end
  end

  def destroy
    restaurant = Restaurant.find(params[:id])
    if restaurant.destroy
      redirect_to restaurants_path
    else
      redirect_to restaurants_path
    end
  end

  def search
    return nil if params[:input] == ""
    country = Country.where(['name LIKE ?', "%#{params[:input]}%"])
    render json: {keyword: country}
  end
end

private

def restaurant_params
  params.require(:restaurant).permit(:name, :postal_code, :address, :image, :memo, :country_id )
end
