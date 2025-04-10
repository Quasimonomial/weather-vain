# WEATHER VAIN

An exciting weather app!

## Running Locally

To get the enviroment set up, you will need a `.env` file in the same structure as `.env.test`.  Accuweather isn't used so you can ignore that, but you will need to set up an [Apple Service ID and key](https://developer.apple.com/weatherkit/) and get an Api Token from [Mapbox](https://docs.mapbox.com/api/accounts/tokens/).

You can build and set up everything with

`bundle install; rails db:migrate; yarn build`

Run the server with

`rails s`

to get that up and running.

The OpenApi Docs are at `/api-docs`

Test suites can be run with `rspec` and `yarn test`

## App Structure

We only care about American Weather.

We have two things we are doing with our API calls - autocompleting addresses and giving a simple weather report back. We then Cache by Zip code, returning the weather from the middle of that Zip code.

We also fetch Zip codes and Cache the result, because we need to be able to transform Zipcodes in a normalized way into Latitude / Longitude, because that is what our external APIs expect.

We have two APIs, Apple Weatherkit and the Government's Weather API; if the Apple Weatherkit call fails for any reason we default to the other external service, and we normalize that into a Daily forecast. We use adapter classes to make sure that each external API formats the data in the same way; we could add additional APIs such as accuweather in the future if we so choose.

The swagger docs contain the shapes of our responses; the Zip code model is annotated.

Our flow is Controller -> Service -> Cals Adapter to API -> API Class -> returns standardized object to render as JSON. See specs for examples.