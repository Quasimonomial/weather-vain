import React from 'react';

import { ForecastDaily } from '../../types/api';
import WeatherDay from './WeatherDay';

interface DailyForecastProps {
  weekForecast: ForecastDaily[];
}

const DailyForecast: React.FC<DailyForecastProps> = ({ weekForecast }) => {
    return (
    <div className="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
      {weekForecast.map((day, index) => (
        <div className="col" key={index}>
          <WeatherDay forecast={day} />
        </div>
      ))}
    </div>
  );
};

export default DailyForecast;
