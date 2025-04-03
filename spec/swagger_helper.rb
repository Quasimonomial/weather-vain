# frozen_string_literal: true

# TODO: Update after deploy

require "rails_helper"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join("swagger").to_s

  config.openapi_format = :yaml

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "WeatherVain Backend API V1",
        version: "v1"
      },
      paths: {},
      servers: [
        {
          url: "https://{defaultHost}",
          description: "Weather Api Backend Service"
        }
      ],
      components: {
        schemas: {
          address: {
            type: "object",
            properties: {
              street_address: { type: "string" },
              city: { type: "string" },
              country: { type: "string" },
              state: { type: "string" },
              zip_code: { type: "string" }
            }
          },

          address_search_query: {
            query: { type: "string" }
          },

          address_search_resp: {
            address_matches: {
              type: "array",
              items: { "$ref" => "#/components/schemas/address" }
            }
          },

          forecast_query: {
            address: {
              type: "object",
              properties: { '$ref' => '#/components/schemas/address' }
            }
          },

          forecast_resp: {
            address_matches: {
              type: "array",
              items: { '$ref' => '#/components/schemas/forecast_item' }
            }
          },

          forecast_item: {
            type: "object",
            properties: {
              start_time: { type: "string" },
              end_time: { type: "string" },
              temperature_low: { type: "integer" },
              temperature_high: { type: "integer" },
              precipitation: { type: "string" },
              skies: { type: "string" }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
