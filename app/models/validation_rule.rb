class ValidationRule < ApplicationRecord
  belongs_to :event

  validates_presence_of :validation_type, :user_field, :failure_message
end
