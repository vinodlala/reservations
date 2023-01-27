class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all

    render
  end

  def create
  end
end
