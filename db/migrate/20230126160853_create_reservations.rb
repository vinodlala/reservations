class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :contact_email
      t.string :contact_phone
      t.string :party_name
      t.integer :party_size
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
