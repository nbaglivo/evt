class AddAttendantsToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :attendees, :json, default: []
  end
end
