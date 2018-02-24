class CreateValidationRules < ActiveRecord::Migration[5.0]
  def change
    create_table :validation_rules do |t|
      t.string :name
      t.string :failure_message
      t.string :validation_type
      t.string :user_field

      t.timestamps
    end
  end
end
