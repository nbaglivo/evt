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

  describe 'POST /events' do
    let(:valid_attributes) {
      { name: 'My awesome event', date: '2018-04-23T18:25:43.511Z' }.to_json
    }

    context 'when the request is valid' do
      before { post '/events', params: valid_attributes, headers: headers }

      it 'creates a event' do
        expect(json['name']).to eq('My awesome event')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the date is missing' do
      let(:invalid_attributes) {
        { name: 'My awesome event' }.to_json
      }
      before { post '/events', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Date can't be blank/)
      end
    end

    context 'when the name is missing' do
      let(:invalid_attributes) {
        { date: '2018-04-23T18:25:43.511Z' }.to_json
      }
      before { post '/events', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

end
