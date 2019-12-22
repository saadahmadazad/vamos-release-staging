class Api::V1::RoomsController < Api::V1::ApplicationController
  before_action :set_room, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /api/v1/rooms
  # GET /api/v1/rooms?facility=[facility_id]
  def index
    rooms = Array.new
    if params[:facility].nil?
      # 自分の施設情報だけを返す
      facilities = current_user.facilities
      facilities.each do |facility|
        rooms.concat(facility.rooms)
      end
    else
      # facility=[facility_id]
      facility = Facility.find_by(id: params[:facility].to_i)
      # 施設IDが存在しない場合
      if facility.nil?
        response = {
          status: 'NotFound',
          message: 'rooms not found'
        }
        return render json: response, status: 404
      end
      # ユーザーの施設IDでない場合
      if facility.user_id != current_user.id
        response = {
          status: 'NotFound',
          message: 'rooms not found'
        }
        return render json: response, status: 404
      end
      rooms.concat(facility.rooms)
    end

    render json: {
      status: 'Success',
      message: '',
      rooms: rooms.as_json(except: [
        :created_at,
        :updated_at
      ], include: [
        :ota_rooms
      ])
    }, status: 200
  end

  # GET /api/v1/rooms/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @room.user.id
      response = {
        status: 'NotFound',
        message: 'room not found'
      }
      return render json: response, status: 404
    end

    render json: {
      status: 'success',
      message: '',
      room: @room.as_json(except: [
        :created_at,
        :updated_at
      ], include: [
        :ota_rooms
      ])
    }, status: 200
  end

  # POST /api/v1/rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      default_otum = current_user.ota.select do |otum|
        otum.provider == 'default'
      end

      ota_room = OtaRoom.new({
        status: :linked,
        room_id: @room.id,
        name: @room.name,
        otum_id: default_otum[0].id
      })

      if ota_room.save
        render json: {
          status: 'success',
          message: '',
          room: @room.as_json(except: [
            :created_at,
            :updated_at
          ], include: [
            :ota_rooms
          ])
        }, status: 201
      else
        response = {
          status: 'InternalServerError',
          message: 'fail to create ota_room'
        }
        render json: response, status: 500
      end
    else
      response = {
        status: 'BadRequest',
        message: 'fail to create room'
      }
      render json: response, status: 400
    end
  end

  # PATCH/PUT /api/v1/rooms/1
  def update
    # 自分の部屋以外だとリジェクト
    if current_user.id != @room.user.id
      response = {
        status: 'NotFound',
        message: 'room not found'
      }
      render json: response, status: 404
    end

    if @room.update(room_params)
      render json: {
        status: 'success',
        message: '',
        room: @room.as_json(except: [
          :created_at,
          :updated_at
        ], include: [
          :ota_rooms
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update room'
      }
      render json: response, status: 400
    end
  end

  # DELETE /api/v1/rooms/1
  def destroy
    # 自分の施設以外だとリジェクト
    if current_user.id != @room.user.id
      response = {
        status: 'NotFound',
        message: 'room not found'
      }
      return render json: response, status: 404
    end

    @room.destroy
    response = {
      status: 'success',
      message: ''
    }
    render json: response, status: 200
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
