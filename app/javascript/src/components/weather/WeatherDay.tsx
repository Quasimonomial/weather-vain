// src/components/weather/WeatherDay.tsx
import React from 'react';
import { format } from 'date-fns';

import { ForecastDaily } from '../../types/api';
import WeatherIcon from './WeatherIcon';

interface WeatherDayProps {
  forecast: ForecastDaily;
}

const WeatherDay: React.FC<WeatherDayProps> = ({ forecast }) => {
  return (
    <div className="card h-100 shadow-sm">
      <div className="card-header text-center bg-light">
        {format(new Date(forecast.start_time), 'EEEE, MMMM do')}
      </div>
      <div className="card-body text-center">
        <div className="my-3">
            <WeatherIcon condition={forecast.skies}/>
        </div>

        <div className="my-3">
          <h5 className="d-flex justify-content-center align-items-center">
            <span className="text-danger me-2">
              {forecast.temperature_high}°F
            </span>
            <span className="text-secondary fs-6">
              {forecast.temperature_low}°F
            </span>
          </h5>
        </div>

        <div className="d-flex justify-content-between text-muted small">
          <span>
            <i className="bi bi-droplet-fill me-1"></i>
            {forecast.precipitation}%
          </span>
          <span className="text-capitalize">
            {/* TODO: probably want some specific service to do formatting I don't think views should really be responsible for this kind of thing */}
            {forecast.skies.replace('_', ' ')}
          </span>
        </div>
      </div>
    </div>
  );
};

export default WeatherDay;
