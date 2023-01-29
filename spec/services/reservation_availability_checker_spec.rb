require 'rails_helper'

describe ReservationAvailabilityChecker do
  subject(:service) { ReservationAvailabilityChecker }

  describe "#call" do
    let(:service_call) do
      service.call(
        party_size: 6,
        starts_at: starts_at,
        ends_at: ends_at,
      )
    end

    let(:starts_at) { DateTime.new(2023, 2, 1, 22, 0, 0) }
    let(:ends_at) { DateTime.new(2023, 2, 1, 23, 0, 0) }

    it "returns true" do
      expect(service_call).to be true
    end

    context "when 6 seats are taken for the same time period" do
      before do
        create(
          :reservation,
          party_size: 6,
          starts_at: starts_at,
          ends_at: ends_at,
        )
      end

      it "returns false" do
        expect(service_call).to be false
      end
    end

    context "when 6 seats are taken for an overlapping earlier time period" do
      before do
        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at - 30.minutes,
          ends_at: ends_at - 30.minutes,
        )

        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at - 30.minutes,
          ends_at: ends_at - 30.minutes,
        )
      end

      it "returns false" do
        expect(service_call).to be false
      end
    end

    context "when 6 seats are taken for a non-overlapping earlier time period" do
      before do
        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at - 60.minutes,
          ends_at: ends_at - 60.minutes,
        )

        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at - 60.minutes,
          ends_at: ends_at - 60.minutes,
        )
      end

      it "returns true" do
        expect(service_call).to be true
      end
    end

    context "when 6 seats are taken for an overlapping later time period" do
      before do
        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at + 30.minutes,
          ends_at: ends_at + 30.minutes,
        )

        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at + 30.minutes,
          ends_at: ends_at + 30.minutes,
        )
      end

      it "returns false" do
        expect(service_call).to be false
      end
    end

    context "when 6 seats are taken for a non-overlapping later time period" do
      before do
        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at + 60.minutes,
          ends_at: ends_at + 60.minutes,
        )

        create(
          :reservation,
          party_size: 3,
          starts_at: starts_at + 60.minutes,
          ends_at: ends_at + 60.minutes,
        )
      end

      it "returns true" do
        expect(service_call).to be true
      end
    end
  end
end