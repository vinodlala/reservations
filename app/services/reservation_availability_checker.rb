class ReservationAvailabilityChecker
  attr_reader :party_size
  attr_reader :starts_at
  attr_reader :ends_at

  MAX_PARTY_CAPACITY = 10

  def self.call(party_size:, starts_at:, ends_at:)
    new(party_size:, starts_at:, ends_at:).call
  end

  def initialize(party_size:, starts_at:, ends_at:)
    @party_size = party_size.to_i
    @starts_at = starts_at
    @ends_at = ends_at
  end

  def call
    current_party_capacity = 0

    overlapping_slots.each do |slot|
      current_party_capacity += slot.party_size
    end

    return true if current_party_capacity + party_size <= MAX_PARTY_CAPACITY

    false
  end

  def overlapping_slots
    # Reservation.where(starts_at: @starts_at, ends_at: @ends_at)

    Reservation.where(
      "(starts_at <= ? and ? < ends_at) or (starts_at < ? and ? <= ends_at)",
      starts_at,
      starts_at,
      ends_at,
      ends_at,
    )
  end
end
