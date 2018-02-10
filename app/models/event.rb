class Event < ApplicationRecord
  belongs_to :owner, :class_name => "User", foreign_key: 'owner_id'
  # validation
  validates_presence_of :name, :date
end
