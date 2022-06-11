class BookingsController < ApplicationController

  def index
    @bookings = Booking.all
  end

  def show
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def new
    @booking = Booking.new
    @trip = Trip.find(params[:trip_id])
    authorize @booking
  end

  def create
    # seteo las instancias
    @booking = Booking.new(booking_params)
    @trip = Trip.find(params[:trip_id])

    # asigno dependencias
    @booking.user = current_user
    @booking.trip = @trip
    @booking.status = "pending"

    # Autorizo
    authorize @booking

    if @booking.passengers <= @trip.number_of_passengers
      @booking.save
      redirect_to trip_booking_path(@trip, @booking)
    else
      flash[:notice] = "Error en la capacidad"
      render :new
    end
  end

  # def edit
  #   @booking = Booking.find(params[:id])
  # end

  # def update
  #   @booking = Booking.find(params[:id])
  #   if @booking.update(booking_params)
  #     redirect_to booking_path(@booking)
  #   else
  #     render :new
  #   end
  # end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path(@booking)
  end

  def accept_booking
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = "Accepted"
    @booking.save
    redirect_to my_trips_path
  end

  def reject_booking
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = "Rejected"
    @booking.save
    redirect_to my_trips_path
  end

  private

  def booking_params
    params.require(:booking).permit(:user, :trip, :status, :passengers)
  end
end
