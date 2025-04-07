import { ApiService } from '../../src/services/apiService';

const mockFetch = jest.fn();
global.fetch = mockFetch;

describe('ApiService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('#fetch', () => {
    it('should return the data on a 200 success', async () => {
      const mockSomeResp = { zip: 12345 };

      mockFetch.mockResolvedValueOnce({
        status: 200,
        json: jest.fn().mockResolvedValueOnce(mockSomeResp),
      });

      const result = await ApiService.fetch('/api/test');
      expect(mockFetch).toHaveBeenCalledWith('/api/test', {
        headers: {
          'Content-Type': 'application/json',
        },
      });
      expect(result).toEqual(mockSomeResp);
    });

    it('should throw ApiError on non-200 response', async () => {
      mockFetch.mockResolvedValueOnce({
        status: 400,
        json: jest.fn().mockResolvedValueOnce({ error: 'Query is required!' }),
      });

      await expect(async () => {
        await ApiService.fetch('/api/v1/addresses');
      }).rejects.toMatchObject({
        name: 'ApiError',
        status: 400,
        message: 'Query is required!',
      });
    });

    it('should throw on other errors', async () => {
      const networkError = new Error('Backend could not be found!');
      mockFetch.mockRejectedValueOnce(networkError);

      // Make request and expect error
      await expect(async () => {
        await ApiService.fetch('/api/test');
      }).rejects.toMatchObject({
        name: 'ApiError',
        status: 500,
        message: 'Backend could not be found!',
      });
    });
  });

  describe('#post', () => {
    it('should make a POST request with JSON body', async () => {
      const mockedAddressList = [
        {
          street_address: '123 Fake Street',
          city: 'Springfield',
          state: 'IL',
          zip_code: '62701',
          country: 'US',
        },
      ];
      const mockResp = {
        address_matches: mockedAddressList,
      };

      mockFetch.mockResolvedValueOnce({
        status: 200,
        json: jest.fn().mockResolvedValueOnce(mockResp),
      });

      const requestBody = { query: '123 Fake Street' };

      const result = await ApiService.post('/api/v1/addresses', requestBody);

      expect(mockFetch).toHaveBeenCalledWith('/api/v1/addresses', {
        method: 'POST',
        body: JSON.stringify(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      });

      expect(result).toEqual(mockResp);
    });
  });
});
