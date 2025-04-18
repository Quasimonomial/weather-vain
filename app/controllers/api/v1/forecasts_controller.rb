class Api::V1::ForecastsController < ApplicationController
  def create
    begin
      zc_code = forecast_params[:address][:zip_code]

      if zc_code.blank?
        render json: {
          error: "Zip Code is required!"
        }, status: :bad_request and return
      end

      zip_code = ZipCodeService.find_zip_code(zc_code)

      unless zip_code.valid_zip
        render json: {
          error: "Zip Code is not in use!"
        }, status: :not_found and return
      end

      forecast = WeatherForecastService.get_forecast_by_zip(zip_code)

      render json: { forecast: forecast }, status: :ok
    rescue ZipCodeService::InvalidZipError
      render json: {
        error: "Zip Code is malformed!"
      }, status: :bad_request
    rescue
      render json: {
        error: "Failed to process Forecast, there is no weather today, please do not look outside"
      }, status: :internal_server_error
    end
  end

  private
  def forecast_params
    params.require(:forecast).permit(
      address: [ :street_address, :city, :country, :state, :zip_code ]
    )
  end
end
