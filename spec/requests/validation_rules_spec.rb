require 'rails_helper'

RSpec.describe 'ValidationRule API', type: :request do
  let(:user) { create(:user) }
  let!(:user_events) { create_list(:event, 10, owner: user) }
  let(:event) { user_events.first }
  let(:event_id) { event.id }

  # authorize request
  let(:headers) { valid_headers }

  describe 'GET /events/:id/validation_rules' do
     before { get "/events/#{event_id}/validation_rules", params: {}, headers: headers }

     it 'should return a 200 status code' do
       expect(response).to have_http_status(200)
     end

     context 'when the event does not have any validation rule' do
       it 'should return an empty array' do
         expect(json).to be_empty
       end
     end

     context 'when the event does have validation rules' do
       let!(:event_rules) { create_list(:validation_rule, 2, event: event) }

       before { get "/events/#{event_id}/validation_rules", params: {}, headers: headers }

       it 'should return the rules' do
         expect(json.size).to eq(2)
       end
     end
   end

   describe 'POST /events/:id/validation_rules' do
    let(:valid_attributes) {
      {
        validation_type: 'is_true',
        user_field: 'some_field',
        failure_message: 'failed'
      }
    }

    context 'when validation_type, user_field and failure_message are present' do
      before { post "/events/#{event_id}/validation_rules", params: valid_attributes.to_json, headers: headers }

      it 'creates a validation rule' do
        expect(json).not_to be_empty

        expect(json['id']).not_to be_nil
        expect(json['validation_type']).to eq(valid_attributes[:validation_type])
        expect(json['user_field']).to eq(valid_attributes[:user_field])
        expect(json['failure_message']).to eq(valid_attributes[:failure_message])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the validation_type is missing' do
      let(:invalid_attributes) {
        {
          user_field: 'some_field',
          failure_message: 'failed'
        }
      }
      before { post "/events/#{event_id}/validation_rules", params: invalid_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Validation type can't be blank/)
      end
    end

    context 'when the user_field is missing' do
      let(:invalid_attributes) {
        {
          validation_type: 'is_true',
          failure_message: 'failed'
        }
      }
      before { post "/events/#{event_id}/validation_rules", params: invalid_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: User field can't be blank/)
      end
    end

    context 'when the failure_message is missing' do
      let(:invalid_attributes) {
        {
          validation_type: 'is_true',
          user_field: 'some_field'
        }
      }
      before { post "/events/#{event_id}/validation_rules", params: invalid_attributes.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Failure message can't be blank/)
      end
    end

  end

  describe 'DELETE /events/:id/validation_rules/:validation_rule_id' do

    context 'when the validation rule exists' do
      let!(:validation_rule_id) { create(:validation_rule, event: event).id }

      before { delete "/events/#{event_id}/validation_rules/#{validation_rule_id}", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the validation rule does not exist' do
      before { delete "/events/#{event_id}/validation_rules/10000", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find ValidationRule/)
      end
    end

  end
end
