require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  describe "GET /reservations" do
    it "returns http ok" do
      headers = { "ACCEPT" => "application/json" }

      get "/reservations", headers: headers

      expect(response).to have_http_status(200)
    end
  end

  describe "POST /reservations" do
    let(:headers) do
      { "ACCEPT" => "application/json" }
    end

    let(:params) do
      {
        contact_email: "1@usa.net",
        contact_phone: "2125551234",
        party_name: "name",
        party_size: 6,
        starts_at: "2023-02-01T11:00:00.000Z",
        ends_at: "2023-02-01T12:00:00.000Z",
      }
    end

    it "returns http created" do
      post "/reservations",
           headers: headers,
           params: params

      expect(response).to have_http_status(201)

      data = JSON.parse(response.body)

      expect(data["reservation"]["contact_email"]).to eq "1@usa.net"
      expect(data["reservation"]["contact_phone"]).to eq "2125551234"
      expect(data["reservation"]["party_name"]).to eq "name"
      expect(data["reservation"]["party_size"]).to eq 6
      expect(data["reservation"]["starts_at"]).to eq "2023-02-01T11:00:00.000Z"

      expect(Reservation.where(params).size).to eq 1
    end

    context "when there are no slots available" do
      before do
        create(
          :reservation,
          params
        )
      end

      it "returns http bad_request" do
        post "/reservations",
             headers: headers,
             params: params

        expect(response).to have_http_status(400)

        data = JSON.parse(response.body)

        expect(data["message"]).to eq "We cannot fit that many people for that time slot."

        expect(Reservation.where(params).size).to eq 1
      end
    end
  end
end
