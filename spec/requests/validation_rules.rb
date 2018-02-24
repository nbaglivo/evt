require 'rails_helper'

RSpec.describe 'ValidationRule API', type: :request do
  let(:user) { create(:user) }
  let!(:user_events) { create_list(:event, 10, owner: user) }
  let(:event) { user_events.first }
  let(:event_id) { event.id }

  # authorize request
  let(:headers) { valid_headers }

  describe 'GET /events/:id/validation_rules' do
    before { get '/events/#{event_id}/validation_rules', params: {}, headers: headers }

    it 'should return a 200 status code' do
      expect(response).to have_http_status(200)
    end

    context 'when the event does not have any validation rule' do
      it 'should return an empty array' do
        expect(json).to be_empty
      end
    end

    context 'when the event does have validation rules' do
      before(:all) do
        event.validation_rules << ValidationRule.new(
          validation_type: 'is_true',
          user_field: 'field'
        )

        event.validation_rules << ValidationRule.new(
          validation_type: 'is_more_than_zero',
          user_field: 'other_field'
        )
      end

      it 'should return the rules' do
        expect(json.size).to eq(2)
      end
    end
  end
end
