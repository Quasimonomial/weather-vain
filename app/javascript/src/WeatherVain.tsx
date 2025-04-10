import React, { useState } from "react";

import DailyForecast from "./components/weather/DailyForecast";
import SearchContainer from "./components/address-search/SearchContainer";

import { Address, ForecastDaily } from "./types/api"
import { WeatherService } from "./services/weatherService";



// Well my editor decided this specific file gets to have 4 space tabs I guess

const WeatherVain: React.FC = () => {
    const forecastService = new WeatherService()

    const [forecast, setForecast] = useState<ForecastDaily[]>([]);

    const handleAddressSelect = async (address: Address) => {
        setForecast([])
        try {
            const weatherService = new WeatherService();

            const forecastResults = await weatherService.getDailyForecast(address);
            setForecast(forecastResults);
        } catch (err) {
            console.error('Error fetching forecast:', err);
        }
    }

    return (
        <div>
            <h1>Weather Vain</h1>
            <div>
                <SearchContainer onAddressSelect={handleAddressSelect}/>
            </div>
            <div>
                <DailyForecast weekForecast={forecast}/>
            </div>
        </div>
    )
}

export default WeatherVain;
