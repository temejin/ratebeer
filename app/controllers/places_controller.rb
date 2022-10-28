class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.get_place_information(params[:id], session[:last_search])
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:last_search] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end
end
