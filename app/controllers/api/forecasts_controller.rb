class Api::ForecastsController < ApplicationController
  def create
    zc_code = forecast_params[:address][:zip_code]
    zip_code = ZipCodeService.find_zip_code(zc_code)
    forecast = WeatherForecastService.get_forecast_by_zip(zip_code)

    render json: { forecast: forecast }, status: :ok
  end

  private
  def forecast_params
    params.require(:forecast).permit(
      address: [ :street_address, :city, :country, :state, :zip_code ]
    )
  end
end
