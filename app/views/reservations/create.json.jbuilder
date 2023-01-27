json.reservation do
  json.contact_email @reservation.contact_email
  json.contact_phone @reservation.contact_phone
  json.party_ney @reservation.party_name
  json.party_size @reservation.party_size
  json.reservation_starts_at @reservation.reservation_starts_at
end
