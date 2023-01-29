class ReservationAvailabilityChecker
  DEFAULT_RESERVATION_TIME = 60.minutes
  def self.call
    new.call
  end
  def initialize(party_size:, reservation_starts_at:)
    @party_size = party_size
    @reservation_starts_at = reservation_starts_at
    @reservation_ends_at = reservation_starts_at + DEFAULT_RESERVATION_TIME
  end

  def call
    Reservation
      .where(
        "reservation_starts_at >= ? or reservation_starts_at < ?",
        @reservation_starts_at,
        @reservation_ends_at
      )
  end
end
