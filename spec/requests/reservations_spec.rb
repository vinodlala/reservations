require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:headers) do
    { "ACCEPT" => "application/json" }
  end

  describe "GET /reservations" do
    before do
      create(:reservation)
      create(:reservation, contact_email: "2@usa.net")
      create(:reservation, contact_phone: "2222222222")
      create(:reservation, party_name: "name 2")
      create(:reservation, party_size: "4")
    end

    it "returns http ok" do
      get "/reservations", headers: headers

      expect(response).to have_http_status(200)

      data = JSON.parse(response.body)

      expect(data["reservations"].size).to eq 5
    end

    context "when contact_email is passed" do
      it "returns http ok" do
        get "/reservations", headers: headers, params: { contact_email: "2@usa.net" }

        expect(response).to have_http_status(200)

        data = JSON.parse(response.body)

        expect(data["reservations"].size).to eq 1
      end
    end

    context "when contact_phone is passed" do
      it "returns http ok" do
        get "/reservations", headers: headers, params: { contact_phone: "2222222222" }

        expect(response).to have_http_status(200)

        data = JSON.parse(response.body)

        expect(data["reservations"].size).to eq 1
      end
    end

    context "when party_name is passed" do
      it "returns http ok" do
        get "/reservations", headers: headers, params: { party_name: "name 2" }

        expect(response).to have_http_status(200)

        data = JSON.parse(response.body)

        expect(data["reservations"].size).to eq 1
      end
    end

    context "when party_size is passed" do
      it "returns http ok" do
        get "/reservations",
            headers: headers,
            params: {
              contact_email: "1@usa.net",
              contact_phone: "2125551234",
              party_name: "name",
              party_size: "2",
            }

        expect(response).to have_http_status(200)

        data = JSON.parse(response.body)

        expect(data["reservations"].size).to eq 1
      end
    end

    context "when multiple params are passed" do
      it "returns http ok" do
        get "/reservations", headers: headers, params: { party_size: "4" }

        expect(response).to have_http_status(200)

        data = JSON.parse(response.body)

        expect(data["reservations"].size).to eq 1
      end
    end

    context "when starts_at and ends_at are passed" do
      it "returns http ok" do
        get "/reservations",
            headers: headers,
            params: {
              starts_at: "2023-02-01T22:30:00.000Z",
              ends_at: "2023-02-01T23:30:00.000Z",
            }

        expect(response).to have_http_status(200)

        data = JSON.parse(response.body)

        expect(data["reservations"].size).to eq 5
      end
    end
  end

  describe "POST /reservations" do
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
