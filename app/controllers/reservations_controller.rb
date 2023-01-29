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

    if params[:starts_at]
      starts_at = DateTime.parse(params[:starts_at])
    end

    if params[:ends_at]
      ends_at = DateTime.parse(params[:ends_at])
    end

    @reservations = if where_hash.present? && starts_at.present? && ends_at.present?
                      Reservation.where(where_hash).where(
                        "(starts_at <= ? and ? < ends_at) or "\
                        "(starts_at < ? and ? <= ends_at) or "\
                        "(? < starts_at and ends_at < ?)",
                        starts_at,
                        starts_at,
                        ends_at,
                        ends_at,
                        starts_at,
                        ends_at,
                      )
                    elsif where_hash.present?
                      Reservation.where(where_hash)
                    elsif starts_at.present? && ends_at.present?
                      Reservation.where(where_hash).where(
                        "(starts_at <= ? and ? < ends_at) or "\
                        "(starts_at < ? and ? <= ends_at) or "\
                        "(? < starts_at and ends_at < ?)",
                        starts_at,
                        starts_at,
                        ends_at,
                        ends_at,
                        starts_at,
                        ends_at,
                      )
                    else
                      Reservation.all
                    end

    render status: :ok
  end

  def create
    unless slot_available?
      render(
        json: {
          message: "We cannot fit that many people for that time slot."
        },
        status: :bad_request
      ) and return
    end

    @reservation = Reservation.create(
      contact_email: params[:contact_email],
      contact_phone: params[:contact_phone],
      party_name: params[:party_name],
      party_size: params[:party_size],
      starts_at: starts_at,
      ends_at: ends_at,
    )

    render status: :created
  end

  def slot_available?
    ReservationAvailabilityChecker.call(
      party_size: params[:party_size].to_i,
      starts_at: starts_at,
      ends_at: ends_at,
    )
  end

  def starts_at
    DateTime.parse(params[:starts_at])
  end

  def ends_at
    DateTime.parse(params[:ends_at])
  end
end
