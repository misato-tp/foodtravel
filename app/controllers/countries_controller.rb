class CountriesController < ApplicationController
  def search_restaurant_by_country
    @restaurants = Restaurant.where(country_id: params[:country_id])
  end
end
