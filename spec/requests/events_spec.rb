require 'rails_helper'

RSpec.describe 'Events API', type: :request do
  let(:user) { create(:user) }
  let!(:user_events) { create_list(:event, 10, owner: user) }

  let!(:other_user_events) { create_list(:event, 10) }

  # authorize request
  let(:headers) { valid_headers }

  describe 'GET /events' do
    before { get '/events', params: {}, headers: headers }

    it 'returns events' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

end
