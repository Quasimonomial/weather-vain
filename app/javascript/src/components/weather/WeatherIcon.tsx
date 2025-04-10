import React from 'react'
import { SkyCondition } from '../../types/api';

interface WeatherIconProps {
  condition: SkyCondition
}

const WeatherIcon: React.FC<WeatherIconProps> = ({condition}) => {
  const skyConditionToIconClass = (condition: SkyCondition): string => {
    // https://getbootstrap.com/docs/4.0/utilities/colors/ okay eventually need better colors for these)
    switch (condition) {
      case 'sunny':
        return "bi bi-sun-fill text-warning";
      case 'partly_cloudy':
        return "bi bi-cloud-sun-fill text-secondary"
      case 'cloudy':
        return "bi bi-cloud-fill text-secondary"
      case 'rain':
        return "bi bi-cloud-rain-fill text-primary"
      case 'snow':
        return "bi bi-snow text-info"
      case 'storm':
        return "bi bi-cloud-lightning-rain-fill text-dark"
      default:
        return "bi bi-question-circle text-muted"
    }
  }

  return (
    <i className={ skyConditionToIconClass(condition) } style={{ fontSize: '2.5rem' }} />
  )
}

export default WeatherIcon;
