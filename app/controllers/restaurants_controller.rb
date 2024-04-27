class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  def index
    @restaurants = Restaurant.all
    @q = Restaurant.ransack(params[:q])
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

  def search_country
    return nil if params[:input] == ""
    country = Country.where(['name LIKE ?', "%#{params[:input]}%"])
    render json: {keyword: country}
  end

  def search_restaurant_by_gps
    @restaurants = Restaurant.all
  end

  def search_restaurant_by_keywords
    @q = Restaurant.ransack(search_params)
    keywords = search_params[:name_or_address_cont].split(/[\p{blank}\s]+/)
    grouping_hash = keywords.reduce({}){|hash, word| hash.merge(word => { name_or_address_cont: word})}
    @results = Restaurant.ransack({ combinator: 'and', groupings: grouping_hash }).result
  end
end
private

def restaurant_params
  params.require(:restaurant).permit(:name, :postal_code, :address, :image, :memo, :country_id )
end

def search_params
  params.require(:q).permit(:name_or_address_cont)
end
