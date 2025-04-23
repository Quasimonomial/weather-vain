import React from 'react';

interface SearchBarProps {
  onQueryChange: (query: string) => void;
  query: string;
}

const SearchBar: React.FC<SearchBarProps> = ({ onQueryChange, query }) => {
  return (
    <div className="mb-3">
      <div className='input-group'>
        <span className="input-group-text bg-light">
          <i className="bi bi-search"></i>
        </span>

        <input
          type="text"
          className="form-control form-control-lg shadow-none border-start-0"
          placeholder="Enter your address"
          value={query}
          onChange={ (e) => onQueryChange(e.target.value) }
          aria-label="Search for location"
        />
      </div>
    </div>
  )
}

export default SearchBar;
