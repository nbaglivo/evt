require 'rails_helper'

RSpec.describe 'Events API', type: :request do
  let(:user) { create(:user) }
  let!(:user_events) { create_list(:event, 10, owner: user) }
  let(:event) { user_events.first }
  let(:event_id) { event.id }

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
      {
        name: 'My awesome event',
        date: '2018-04-23T18:25:43.511Z',
        attendees: [{ email: 'nico@nico.com' }]
      }
    }

    context 'when name, date and attendees are present' do
      before { post '/events', params: valid_attributes.to_json, headers: headers }

      it 'creates a event' do
        expect(json).not_to be_empty

        expect(json['id']).not_to be_nil
        expect(Time.parse((json['date']).to_s)).to eq(valid_attributes[:date])
        expect(json['name']).to eq(valid_attributes[:name])
        expect(json['attendees'].to_json).to eq([{ email: 'nico@nico.com' }].to_json)

        expect(json['owner_id']).to be_nil
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when attendees is missing' do
      let(:valid_attributes) {
        {
          name: 'My awesome event',
          date: '2018-04-23T18:25:43.511Z'
        }
      }
      before { post '/events', params: valid_attributes.to_json, headers: headers }

      it 'creates an event with no attendees' do
        expect(json).not_to be_empty

        expect(json['id']).not_to be_nil
        expect(Time.parse((json['date']).to_s)).to eq(valid_attributes[:date])
        expect(json['name']).to eq(valid_attributes[:name])
        expect(json['attendees']).to eq([])

        expect(json['owner_id']).to be_nil
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

  describe 'GET /events/:id' do
    before { get "/events/#{event_id}", params: {}, headers: headers }

    context 'when the record exists' do

      context 'when the record belongs to the authenticated user' do
        it 'returns the event' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(event_id)
          expect(Time.parse((json['date']).to_s)).to eq(event.date.utc.to_s)
          expect(json['name']).to eq(event.name)
          expect(json['attendees']).to eq([{ "email" => 'nico@nico.com'}])

          expect(json['owner_id']).to be_nil
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not belong to the authenticated user' do
        let(:event_id) { other_user_events.first.id }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Event/)
        end
      end
    end

    context 'when the record does not exist' do
      let(:event_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end

  describe 'PUT /events/:id' do
    let(:valid_attributes) {
      { name: 'The most awesome event', attendees: [{ email: 'nico@nico.com' }] }.to_json
    }
    before { put "/events/#{event_id}", params: valid_attributes, headers: headers }

    context 'when the record belongs to the authenticated user' do

      context 'when the record exists' do

        it 'updates the record' do
          expect(json).not_to be_empty

          expect(json['id']).to eq(event_id)
          expect(Time.parse((json['date']).to_s)).to eq(event[:date].utc.to_s)
          expect(json['name']).to eq('The most awesome event')
          expect(json['attendees'].to_json).to eq([{ email: 'nico@nico.com' }].to_json)

          expect(json['owner_id']).to be_nil
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not belong to the authenticated user' do
        let(:event_id) { other_user_events.first.id }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Event/)
        end
      end

    end

    context 'when the record does not exist' do
      let(:event_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end

  describe 'DELETE /events/:id' do
    before { delete "/events/#{event_id}", params: {}, headers: headers }

    context 'when the record exists' do
      context 'when the record belongs to the authenticated user' do

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when the record does not belong to the authenticated user' do
        let(:event_id) { other_user_events.first.id }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Event/)
        end
      end
    end

    context 'when the record does not exist' do
      let(:event_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end

  end

  describe 'POST /events/:id/check' do
    let(:body) {
      { email: 'nico@nico.com' }.to_json
    }
    before { post "/events/#{event_id}/check", params: body, headers: headers }

    context 'when the record belongs to the authenticated user' do

      context 'when the record exists' do

        it 'updates the record with checked true' do
          expect(json).not_to be_empty

          expect(json['id']).to eq(event_id)

          expect(json['attendees'].to_json).to eq([{ email: 'nico@nico.com', checked: true }].to_json)

        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not belong to the authenticated user' do
        let(:event_id) { other_user_events.first.id }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Event/)
        end
      end

    end

    context 'when email is missing' do
      let(:body) {
        { }.to_json
      }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: email is required/)
      end
    end

    context 'when the record does not exist' do
      let(:event_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end
end
