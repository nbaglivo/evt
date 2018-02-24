class Event < ApplicationRecord
  ATTENDEE_JSON_SCHEMA = Rails.root.join('app', 'models', 'schemas', 'attendees.json_schema').to_s

  belongs_to :owner, :class_name => 'User', foreign_key: 'owner_id'
  has_many :validation_rules

  # validation
  validates_presence_of :name, :date
  validates :attendees, json: { message: -> (errors) { errors }, schema: ATTENDEE_JSON_SCHEMA }

  def checkIn(email)
    attendee = attendees.detect{ |attendee| attendee['email'] == email }

    return false unless attendee

    runAttendeeValidations(attendee['data']) if attendee['data']
    attendee[:checked] = true
    save

    return true
  end

  private

  def runAttendeeValidations(attendee_data)
    validation_rules.each{ |rule| rule.validate(attendee_data) }
  end

end
