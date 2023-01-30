class AddIndexToReservations < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, [:starts_at, :ends_at]
    add_index :reservations, :contact_email
    add_index :reservations, :contact_phone
    add_index :reservations, :party_name
    add_index :reservations, :party_size
  end
end
