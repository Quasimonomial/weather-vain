import React, { useState, useEffect, useRef } from 'react';
import SearchBar from './SearchBar';

import { Address } from '../../types/api';
import { AddressService } from '../../services/addressService';
import AddressList from './AddressList';

var _ = require('lodash');

interface SearchContainerProps {
    onAddressSelect: (address: Address) => void
}

const SearchContainer: React.FC<SearchContainerProps> = ({ onAddressSelect }) => {
  const addressService = new AddressService()

  const [query, setQuery] = useState<string>('');
  const [addresses, setAddresses] = useState<Address[]>([]);
  const [isSearching, setIsSearching] = useState<boolean>(false);

  // useRef here solves our issue with the deboucning re-rendering and calling the API too many times and losing state and all this other nonsense
  const debouncedSearch = useRef(
    _.debounce(async (query: string) => {
      if (query.length < 5) {
        setAddresses([]);
        setIsSearching(false);
        return;
      }

      try {
        setIsSearching(true);
        const addressResults = await addressService.getAddressSuggestions(query);
        console.log(addressResults)
        setAddresses(addressResults);
      } catch (error) {
        console.error('Error fetching addresses:', error);
        setAddresses([]);
      } finally {
        setIsSearching(false);
      }
    }, 500)
  ).current;

  const handleAddressSelection = (address: Address) => {
    setAddresses([])
    onAddressSelect(address)
  };

  useEffect(() => {
    debouncedSearch(query);
    return () => {
      debouncedSearch.cancel();
    };
  }, [query, debouncedSearch]);

  return (
    <div>
      <SearchBar
        query={query}
        onQueryChange={setQuery}
      />

      <div className="card shadow-sm mb-6">
        <div className="card-body">
          <AddressList
            addresses={addresses}
            isLoading={isSearching}
            onAddressSelect={handleAddressSelection}
          />
        </div>
      </div>
    </div>
  )
}

export default SearchContainer;
