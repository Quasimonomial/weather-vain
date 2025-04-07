import { ApiError } from '../util/errors';

export const ApiService = {
  async fetch<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      const response = await fetch(endpoint, {
        ...options,
        headers,
      });

      if (!(response.status == 200)) {
        const errorData = await response
          .json()
          .catch(() => ({ error: 'Unknown error' }));
        throw new ApiError(
          errorData.error || `API error: ${response.status}`,
          response.status
        );
      }

      return (await response.json()) as T;
    } catch (error) {
      if (error instanceof ApiError) throw error;
      throw new ApiError(
        error instanceof Error ? error.message : String(error),
        500
      );
    }
  },

  post<T>(
    endpoint: string,
    requestBody: unknown,
    options?: RequestInit
  ): Promise<T> {
    return this.fetch<T>(endpoint, {
      ...options,
      method: 'POST',
      body: JSON.stringify(requestBody),
    });
  },
};

export default ApiService;
