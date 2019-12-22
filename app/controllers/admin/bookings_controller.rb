class Admin::BookingsController < Admin::ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.page(params[:page]).per(20)
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to [:admin, @booking], notice: 'Booking was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    if @booking.update(booking_params)
      redirect_to [:admin, @booking], notice: 'Booking was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    redirect_to admin_bookings_url, notice: 'Booking was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:uid, :status, :checkin, :checkout, :count_room, :price, :price_balance, :price_total, :subscriber_name, :subscriber_kana, :subscriber_tel, :subscriber_email, :subscriber_address, :booking_date, :guest_name, :guest_kana, :payment_method, :number_total, :number_males, :number_females, :number_adults, :number_children, :currency, :ota_room)
    end
end
