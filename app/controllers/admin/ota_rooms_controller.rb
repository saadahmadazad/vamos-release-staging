class Admin::OtaRoomsController < Admin::ApplicationController
  before_action :set_ota_room, only: [:show, :edit, :update, :destroy]

  # GET /ota_rooms
  def index
    @ota_rooms = OtaRoom.page(params[:page]).per(20)
  end

  # GET /ota_rooms/1
  def show
  end

  # GET /ota_rooms/new
  def new
    @ota_room = OtaRoom.new
  end

  # GET /ota_rooms/1/edit
  def edit
  end

  # POST /ota_rooms
  def create
    @ota_room = OtaRoom.new(ota_room_params)

    if @ota_room.save
      redirect_to [:admin, @ota_room], notice: 'Ota room was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ota_rooms/1
  def update
    if @ota_room.update(ota_room_params)
      redirect_to [:admin, @ota_room], notice: 'Ota room was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ota_rooms/1
  def destroy
    @ota_room.destroy
    redirect_to admin_ota_rooms_url, notice: 'Ota room was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ota_room
      @ota_room = OtaRoom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ota_room_params
      params.require(:ota_room).permit(:uid, :status, :ota_id, :room_id)
    end
end
