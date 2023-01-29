require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  describe "GET /reservations" do
    it "returns http success" do
      headers = { "ACCEPT" => "application/json" }

      get "/reservations", headers: headers

      expect(response).to have_http_status(200)
    end
  end

  describe "POST /reservations" do
    it "returns http success" do
      headers = { "ACCEPT" => "application/json" }

      params = {
        contact_email: "1@usa.net",
        contact_phone: "2125551234",
        party_name: "name",
        party_size: 4,
        reservation_starts_at: "2023-02-01T11:00:00.000Z",
      }

      post "/reservations",
           headers: headers,
           params: params

      expect(response).to have_http_status(201)

      data = JSON.parse(response.body)

      expect(data["reservation"]["contact_email"]).to eq "1@usa.net"
      expect(data["reservation"]["contact_phone"]).to eq "2125551234"
      expect(data["reservation"]["party_name"]).to eq "name"
      expect(data["reservation"]["party_size"]).to eq 4
      expect(data["reservation"]["reservation_starts_at"]).to eq "2023-02-01T11:00:00.000Z"
    end
  end
end
