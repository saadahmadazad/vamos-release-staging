class Admin::RoomsController < Admin::ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.page(params[:page]).per(20)
  end

  # GET /rooms/1
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to [:admin, @room], notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      redirect_to [:admin, @room], notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy
    redirect_to admin_rooms_url, notice: 'Room was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :stock_max, :overbooking_thresh, :price, :status, :facility_id)
    end
end
