class Api::AddressesController < ApplicationController
  def create
    query = address_params[:query]
    address_data = AddressService.get_addresses_from_query(query)

    render json: { address_matches: address_data }, status: :ok
  end

  private
  def address_params
    params.require(:address).permit(:query)
  end
end
