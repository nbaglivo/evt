class ValidationRule < ApplicationRecord

  class InvalidAttendee < StandardError; end

  belongs_to :event

  validates_presence_of :validation_type, :user_field, :failure_message

  # Class methods that starts with is_ are the allowed validation types
  # to implement a new method just add a new is_ method here.
  def self.allowed_types
    ValidationRule.methods(false)
      .select { |sym| /\Ais_/.match(sym.to_s) }
      .collect { |sym| sym.to_s }
  end

  validates_inclusion_of :validation_type, in: ValidationRule.allowed_types

  def self.is_true(value)
    value == true
  end

  def self.is_more_than_zero(value)
    (value.is_a? Numeric) && (value > 0)
  end

  def validate(data)
    valid = ValidationRule.send(validation_type.to_sym, data[user_field.to_sym])
    raise ValidationRule::InvalidAttendee.new(failure_message) unless valid
  end
end
