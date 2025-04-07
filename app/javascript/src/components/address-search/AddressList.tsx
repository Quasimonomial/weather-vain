import React from 'react'
import { Address } from '../../types/api'

interface AddressListProps {
    addresses: Address[];
    isLoading: boolean;
    onAddressSelect: (address: Address) => void;
}

const AddressList: React.FC<AddressListProps> = ({
    addresses, isLoading, onAddressSelect
}) => {
  if (isLoading) {
    return (
      <div className="d-flex justify-content-center my-3">
      <div className="spinner-border spinner-border-sm text-primary" role="status">
      <span className="visually-hidden">Loading...</span>
      </div>
      </div>
    );
  }

  if (addresses.length === 0) {
    return null;
  }

  return (
    <div className="list-group mt-3">
      {
        addresses.map((address, index) => (
          <button
            key={index}
            type="button"
            className="list-group-item list-group-item-action d-flex flex-column align-items-start border-start border-4 border-primary"
            onClick={() => onAddressSelect(address)}
          >
          <div className="d-flex w-100 justify-content-between align-items-center">
          <h5 className="mb-1 text-truncate">
            {address.street_address || address.city || address.zip_code}
          </h5>
          <small className="badge bg-light text-dark">Select</small>
          </div>
            <p className="mb-1 text-muted small">
            {[
              address.street_address,
              address.city,
              address.state,
              address.zip_code
            ].filter(Boolean).join(', ')}
          </p>
          </button>
        ))
      }
    </div>
  );
}

export default AddressList;
