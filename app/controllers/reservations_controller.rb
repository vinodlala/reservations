class ReservationsController < ApplicationController
  def index
    where_hash = {}

    %i(
      contact_email
      contact_phone
      party_name
      party_size
    ).each do |key|
      where_hash[key] = params[key] if params[key]
    end

    if params[:reservation_starts_at]
      reservation_starts_at = DateTime.parse(params[:reservation_starts_at])
      where_hash[:reservation_starts_at] = reservation_starts_at
    end

    @reservations = if where_hash.present?
                      Reservation.where(where_hash)
                    else
                      Reservation.all
                    end

    render
  end

  def create
    reservation_starts_at = DateTime.parse(params[:reservation_starts_at])

    @reservation = Reservation.create(
      contact_email: params[:contact_email],
      contact_phone: params[:contact_phone],
      party_name: params[:party_name],
      party_size: params[:party_size],
      reservation_starts_at: reservation_starts_at,
    )

    render
  end
end
