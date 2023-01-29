class Reservation < ApplicationRecord
  validates :contact_email, presence: true
  validates :contact_phone, presence: true
  validates :party_name, presence: true
  validates :party_size, presence: true
  validates :reservation_starts_at, presence: true
end
