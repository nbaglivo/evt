class ValidationRule < ApplicationRecord

  class InvalidAttendee < StandardError; end

  belongs_to :event

  validates_presence_of :validation_type, :user_field, :failure_message

  def is_true(value)
    value == true
  end

  def is_more_than_zero(value)
    (value.is_a? Numeric) && (value > 0)
  end

  def validate(data)
    valid = send(validation_type.to_sym, data[user_field.to_sym])
    raise ValidationRule::InvalidAttendee.new(failure_message) unless valid
  end
end
