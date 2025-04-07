import { AddressService } from '../../src/services/addressService';
import { ApiService } from '../../src/services/apiService';
import { Address, AddressResponse } from '../../src/types/api';

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

describe('AddressService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('#getAddressSuggestions', () => {
    it('Calls a post in the Api Service to the address path with the query', async () => {
      const mockedAddressList: Address[] = [
        {
          street_address: '123 Fake Street',
          city: 'Springfield',
          state: 'IL',
          zip_code: '62701',
          country: 'US',
        },
      ];
      const mockAddressResp: AddressResponse = {
        address_matches: mockedAddressList,
      };
      const addressService = new AddressService();

      mockApiPost.mockResolvedValue(mockAddressResp);

      const response =
        await addressService.getAddressSuggestions('123 Fake Street');

      expect(ApiService.post).toHaveBeenCalledWith('/api/v1/addresses', {
        query: '123 Fake Street',
      });
      expect(response).toEqual(mockedAddressList);
    });
  });
});
