# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_30_134650) do
  create_table "reservations", force: :cascade do |t|
    t.string "contact_email"
    t.string "contact_phone"
    t.string "party_name"
    t.integer "party_size"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_email"], name: "index_reservations_on_contact_email"
    t.index ["contact_phone"], name: "index_reservations_on_contact_phone"
    t.index ["party_name"], name: "index_reservations_on_party_name"
    t.index ["party_size"], name: "index_reservations_on_party_size"
    t.index ["starts_at", "ends_at"], name: "index_reservations_on_starts_at_and_ends_at"
  end

end
