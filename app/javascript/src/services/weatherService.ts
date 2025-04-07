import { Address, ForecastDaily, ForecastResponse } from '../types/api';
import { ApiService } from './apiService';

export class WeatherService {
  async getDailyForecast(address: Address): Promise<ForecastDaily[]> {
    const respData = await ApiService.post<ForecastResponse>(
      '/api/v1/forecasts',
      {
        address: address,
      }
    );
    return respData.forecast;
  }
}
