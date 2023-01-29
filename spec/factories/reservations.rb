FactoryBot.define do
  factory :reservation do
    contact_email { "1@usa.net" }
    contact_phone { "2125551234" }
    party_name { "name" }
    party_size { 2 }
    starts_at { DateTime.new(2023, 2, 1, 22, 0, 0) }
    ends_at { DateTime.new(2023, 2, 1, 22, 0, 0) }
  end
end
