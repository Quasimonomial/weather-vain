export interface Address {
  street_address: string | null;
  city: string | null;
  country: string | null;
  state: string | null;
  zip_code: string;
}

export type SkyCondition =
  | 'sunny'
  | 'partly_cloudy'
  | 'cloudy'
  | 'rain'
  | 'snow'
  | 'storm'
  | 'unknown';

// TODO should probably convert these times to Datetimes directly in the WeatherService w/ error handling etc
export interface ForecastDaily {
  start_time: string;
  end_time: string;
  temperature_high: number;
  temperature_low: number;
  precipitation: number;
  skies: SkyCondition;
}

export interface AddressResponse {
  address_matches: Address[];
}

export interface ForecastResponse {
  forecast: ForecastDaily[];
}

export interface ApiError {
  error: string;
}
