class AddEventToValidationRule < ActiveRecord::Migration[5.0]
  def change
    add_reference :validation_rules, :event, foreign_key: true
  end
end
