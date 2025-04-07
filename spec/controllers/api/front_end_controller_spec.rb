require "rails_helper"

RSpec.describe FrontEndController, type: :controller do
  describe 'GET #index' do
    it "successfully renders the root page" do
      get :index
      expect(response.status).to eq(200)

      expect(response).to render_template(:index)
    end
  end
end
