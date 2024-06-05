class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [
    :index, :show, :search_restaurant_by_gps, :search_restaurant_by_keywords, :search_restaurant_by_map, :search_restaurant_by_map_results
  ]

  def index
    @restaurants = Restaurant.all
    @q = Restaurant.ransack(params[:q])
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @countries = @restaurant.country
    @restaurant_reports = @restaurant.reports.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      flash[:notice] = "お店の登録に成功しました。投稿ありがとう！"
      redirect_to restaurant_path(@restaurant.id)
    else
      flash[:alert] = "お店の登録に失敗しました。"
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
      flash[:notice] = "お店の情報を更新しました。"
      redirect_to restaurant_path(@restaurant.id)
    else
      flash[:alert] = "お店の情報更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.destroy
      Like.where(restaurant_id: @restaurant.id).destroy_all
      flash[:notice] = "お店を削除しました。"
    else
      flash[:alert] = "お店を削除できませんでした。"
    end
    redirect_to restaurants_path
  end

  def search_country
    return nil if params[:input] == ""
    country = Country.where(['name LIKE ?', "%#{params[:input]}%"])
    render json: { keyword: country }
  end

  def search_restaurant_by_gps
    @restaurants = Restaurant.all
  end

  def search_restaurant_by_keywords
    @q = Restaurant.ransack(search_params)
    keywords = search_params[:name_or_address_cont].split(/[\p{blank}\s]+/)
    grouping_hash = keywords.reduce({}) { |hash, word| hash.merge(word => { name_or_address_cont: word }) }
    @results = Restaurant.ransack({ combinator: 'and', groupings: grouping_hash }).result
  end

  def search_restaurant_by_map
  end

  def search_restaurant_by_map_results
    @results = Restaurant.where(country_id: params[:id])
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :postal_code, :address, :image, :memo, :country_id)
  end

  def search_params
    params.require(:q).permit(:name_or_address_cont)
  end
end
