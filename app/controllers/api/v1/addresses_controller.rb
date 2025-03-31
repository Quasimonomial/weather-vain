class Api::V1::AddressesController < ApplicationController
  def create
    query = address_params[:query]

    # We want more generally missing params handling for these controllers the moment we add a hair more complexity
    if query.blank?
      render json: {
        error: "Query is required!"
      }, status: :bad_request and return
    end

    begin
      address_data = AddressService.get_addresses_from_query(query)
      render json: { address_matches: address_data }, status: :ok
    rescue
      render json: { error: "Failed to process Address Lookup" }, status: :internal_server_error
    end
  end

  private
  def address_params
    params.require(:address).permit(:query)
  end
end
