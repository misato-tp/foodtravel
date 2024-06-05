class CountriesController < ApplicationController
  def search_restaurant_by_map_result
    @results = Restaurant.where(country_id: params[:country_id])
  end
end
