import { ApiService } from '../../src/services/apiService';
import { Address, ForecastDaily, ForecastResponse } from '../../src/types/api';
import { WeatherService } from '../../src/services/weatherService';

jest.mock('../../src/services/apiService', () => {
  return {
    ApiService: {
      post: jest.fn(),
    },
  };
});

const mockApiPost = ApiService.post as jest.MockedFunction<
  typeof ApiService.post
>;

describe('WeatherService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('#getDailyForecast', () => {
    it('Calls a post in the Api Service to the address path with the query', async () => {
      const queryAddress: Address = {
        street_address: '123 Fake Street',
        city: 'Springfield',
        state: 'IL',
        zip_code: '62701',
        country: 'US',
      };
      const mockedDailyForecast: ForecastDaily[] = [
        {
          start_time: '2025-03-31T20:00:00-07:00',
          end_time: '2025-04-01T06:00:00-07:00',
          temperature_high: 48,
          temperature_low: 48,
          precipitation: 0,
          skies: 'rain',
        },
        {
          start_time: '2025-04-01T06:00:00-07:00',
          end_time: '2025-04-02T06:00:00-07:00',
          temperature_high: 58,
          temperature_low: 44,
          precipitation: 0,
          skies: 'storm',
        },
        {
          start_time: '2025-04-02T06:00:00-07:00',
          end_time: '2025-04-03T06:00:00-07:00',
          temperature_high: 61,
          temperature_low: 44,
          precipitation: 0,
          skies: 'sunny',
        },
        {
          start_time: '2025-04-03T06:00:00-07:00',
          end_time: '2025-04-04T06:00:00-07:00',
          temperature_high: 62,
          temperature_low: 45,
          precipitation: 0,
          skies: 'sunny',
        },
        {
          start_time: '2025-04-04T06:00:00-07:00',
          end_time: '2025-04-05T06:00:00-07:00',
          temperature_high: 67,
          temperature_low: 48,
          precipitation: 0,
          skies: 'sunny',
        },
        {
          start_time: '2025-04-05T06:00:00-07:00',
          end_time: '2025-04-06T06:00:00-07:00',
          temperature_high: 72,
          temperature_low: 49,
          precipitation: 0,
          skies: 'sunny',
        },
        {
          start_time: '2025-04-06T06:00:00-07:00',
          end_time: '2025-04-07T06:00:00-07:00',
          temperature_high: 73,
          temperature_low: 50,
          precipitation: 0,
          skies: 'sunny',
        },
        {
          start_time: '2025-04-07T06:00:00-07:00',
          end_time: '2025-04-07T18:00:00-07:00',
          temperature_high: 68,
          temperature_low: 68,
          precipitation: 0,
          skies: 'partly_cloudy',
        },
      ];
      const mockForecastResp: ForecastResponse = {
        forecast: mockedDailyForecast,
      };
      const weatherService = new WeatherService();

      mockApiPost.mockResolvedValue(mockForecastResp);

      const response = await weatherService.getDailyForecast(queryAddress);

      expect(ApiService.post).toHaveBeenCalledWith('/api/v1/forecasts', {
        address: queryAddress,
      });
      expect(response).toEqual(mockedDailyForecast);
    });
  });
});
