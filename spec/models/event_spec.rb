require 'rails_helper'

RSpec.describe Event, type: :model do
  subject {
    Event.new(
      name: 'Awesome event',
      date: Date.new,
      attendees: [
        { email: 'nico@fashion.cloud' },
        {
          email: 'jose@fashion.cloud',
          data: { paid: false }
        },
        {
          email: 'almuth@fashion.cloud',
          data: { paid: true }
        }
      ]
    )
  }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:date) }

  it { should belong_to(:owner) }

  describe 'checkIn' do
    context 'when the email does not belong to any attendee' do
      it 'should return false' do
        expect(subject.checkIn('nobody@unknown.com')).to be false
      end
    end

    context 'when the email belongs to an attendee' do

      context 'when the attendee has not a data field' do
        it 'should return true' do
          expect(subject.checkIn('nico@fashion.cloud')).to be true
        end

        it 'should add a checked property on the attendee' do
          subject.checkIn('nico@fashion.cloud')
          expect(subject.attendees[0][:checked]).to be true
        end
      end

      context 'when the attendee has a data field' do
        it 'should run all the validation rules' do
          expect(subject).to receive(:runAttendeeValidations)
          expect(subject.checkIn('almuth@fashion.cloud')).to be true
        end
      end

    end
  end

  describe 'runAttendeeValidations' do

    let(:validation_rules_mock) {
      [
        instance_double('ValidationRule', :validate => nil),
        instance_double('ValidationRule', :validate => nil)
      ]
    }

    before :each do
      allow(subject).to receive(:validation_rules).and_return(validation_rules_mock)
    end

    it 'should call validate on every validation rule' do
      data = {}

      expect(validation_rules_mock[0]).to receive(:validate).with(data)
      expect(validation_rules_mock[1]).to receive(:validate).with(data)

      # By pass private/public control
      subject.send :runAttendeeValidations, data
    end
  end
end
