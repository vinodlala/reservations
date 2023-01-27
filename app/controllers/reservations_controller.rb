class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all

    render
  end

  def create
    reservation_starts_at = DateTime.parse(params[:starts_at])

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
