import { Address, AddressResponse } from '../types/api';
import { ApiService } from './apiService';

export class AddressService {
  async getAddressSuggestions(queryString: string): Promise<Address[]> {
    const respData = await ApiService.post<AddressResponse>(
      '/api/v1/addresses',
      {
        query: queryString,
      }
    );
    return respData.address_matches;
  }
}
