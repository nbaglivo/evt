class AddOwnerIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :owner, foreign_key:  { to_table: :users }
  end
end
