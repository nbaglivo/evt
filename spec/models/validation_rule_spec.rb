require 'rails_helper'

RSpec.describe ValidationRule, type: :model do

  subject {
    ValidationRule.new(
      validation_type: 'is_true',
      user_field: 'some_boolean_field',
      failure_message: 'failed'
    )
  }

  describe 'Model validations' do
    it { should validate_presence_of(:validation_type) }
    it { should validate_presence_of(:user_field) }
    it { should validate_presence_of(:failure_message) }

    it { should allow_value('is_true').for(:validation_type) }
    it { should allow_value('is_more_than_zero').for(:validation_type) }
    it { should_not allow_value('is_some_not_allowed_test').for(:validation_type) }

    it { should belong_to(:event) }
  end

  describe 'Validation methods' do

    describe 'is_true method' do
      it 'should return true if the value is true' do
        expect(subject.is_true(true)).to be true
      end

      it 'should return false if the value is false' do
        expect(subject.is_true(false)).to be false
      end

      it 'should return false if the value is not a boolean' do
        expect(subject.is_true('true')).to be false
      end
    end

    describe 'is_more_than_zero method' do
      it 'should return true if value is more than zero' do
        expect(subject.is_more_than_zero(2)).to be true
      end

      it 'should return true if the value is more than zero even if it is a float number' do
        expect(subject.is_more_than_zero(1.5)).to be true
      end

      it 'should return false if the value is zero' do
        expect(subject.is_more_than_zero(0)).to be false
      end

      it 'should return false if the value is less than zero' do
        expect(subject.is_more_than_zero(-1)).to be false
      end

      it 'should return false if the value is not a number' do
        expect(subject.is_more_than_zero('20')).to be false
      end
    end

    describe 'validate method' do
      let(:user_data){ { some_boolean_field: true, some_numeric_field: 10 } }

      it 'should not raise an error when the condition is true' do
        expect { subject.validate(user_data) }.to_not raise_error
      end

      it 'should raise an error when the condition is false' do
        expect {
          subject.validate({ some_field: false, failure_message: 'failed' })
        }.to raise_error(ValidationRule::InvalidAttendee, 'failed')
      end

      it 'should check that the value is true when validation type is is_true' do
        expect(subject).to receive(:is_true).and_call_original
        subject.validate(user_data)
      end

      it 'should check that the value is more than zero when validation type is is_more_than_zero' do
        isMoreThanZeroRule = ValidationRule.new(
          validation_type: 'is_more_than_zero',
          user_field: 'some_numeric_field'
        )
        expect(isMoreThanZeroRule).to receive(:is_more_than_zero).and_call_original
        isMoreThanZeroRule.validate(user_data)
      end

    end

  end

end
