class Event < ApplicationRecord
  ATTENDEE_JSON_SCHEMA = Rails.root.join('app', 'models', 'schemas', 'attendees.json_schema').to_s

  belongs_to :owner, :class_name => "User", foreign_key: 'owner_id'
  # validation
  validates_presence_of :name, :date
  validates :attendees, json: { message: ->(errors) { errors }, schema: ATTENDEE_JSON_SCHEMA }

  def checkIn(email)
    attendee = attendees.detect{|attendee| attendee["email"] == email }

    if attendee
      validate(attendee["data"]) if attendee["data"]
      attendee[:checked] = true
      save
    end
  end

  private

  def validate(data)
    validator_rules.each{ |validator| validtor.validate }
  end

end
