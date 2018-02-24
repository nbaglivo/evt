require 'rails_helper'

RSpec.describe ValidationRule, type: :model do

  it { should validate_presence_of(:validation_type) }
  it { should validate_presence_of(:user_field) }
  it { should validate_presence_of(:failure_message) }
  it { should belong_to(:event) }
end
