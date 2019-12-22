class Api::V1::OtaRoomsController < Api::V1::ApplicationController
  before_action :set_ota_room, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /api/v1/ota_rooms
  # GET /api/v1/ota_rooms?room=[:room_id]&ota=[:ota_id]
  def index
    ota_rooms = Array.new
    if params[:room].nil? && params[:ota].nil?
      # 自分の施設情報だけを返す

      current_user.ota.select do |otum|
        otum.provider == 'default'
      end.each do |otum|
        ota_rooms.concat(otum.ota_rooms)
      end
    elsif params[:ota].nil?
      room = Room.find_by(id: params[:room].to_i)
      # 部屋IDが存在しない場合
      if room.nil?
        response = {
          status: 'NotFound',
          message: 'room not found'
        }
        return render json: response, status: 404
      end
      # 権限がない場合
      if current_user.id != room.user.id
        response = {
          status: 'NotFound',
          message: 'room not found'
        }
        return render json: response, status: 404
      end
      ota_rooms.concat(room.ota_rooms)
    elsif params[:room].nil?
      otum = Otum.find_by(id: params[:ota].to_i)
      # OTA IDが存在しない場合
      if otum.nil?
        response = {
          status: 'NotFound',
          message: 'ota not found'
        }
        return render json: response, status: 404
      end
      # 権限がない場合
      if current_user.id != otum.user.id
        response = {
          status: 'NotFound',
          message: 'ota not found'
        }
        return render json: response, status: 404
      end
      ota_rooms.concat(otum.ota_rooms)
    else
      # facility=[facility_id]
      facility = Facility.find_by(id: params[:facility].to_i)
      # 施設IDが存在しない場合
      if facility.nil?
        response = {
          status: 'NotFound',
          message: 'ota_rooms not found'
        }
        return render json: response, status: 404
      end
      # ユーザーの施設IDでない場合
      if facility.user_id != current_user.id
        response = {
          status: 'NotFound',
          message: 'ota_rooms not found'
        }
        return render json: response, status: 404
      end
      ota_rooms.concat(facility.ota_rooms)
    end

    render json: {
      status: 'Success',
      message: '',
      ota_rooms: ota_rooms.as_json(except: [
        :created_at,
        :updated_at
      ])
    }, status: 200
  end

  # GET /api/v1/ota_rooms/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @ota_room.room.user.id
      response = {
        status: 'NotFound',
        message: 'ota_room not found'
      }
      return render json: response, status: 404
    end

    render json: {
      status: 'Success',
      message: '',
      ota_room: @ota_room.as_json(except: [
        :created_at,
        :updated_at
      ])
    }, status: 200
  end

  # POST /api/v1/ota_rooms
  def create
    @ota_room = OtaRoom.new(ota_room_params)

    if @ota_room.save
      render json: {
        status: 'Success',
        message: '',
        ota_room: @ota_room.as_json(except: [
          :created_at,
          :updated_at
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to create ota_room'
      }
      render json: response, status: 400
    end
  end

  # PATCH/PUT /api/v1/ota_rooms/1
  def update
    # 自分の施設以外だとリジェクト
    if current_user.id != @ota_room.room.user.id
      response = {
        status: 'NotFound',
        message: 'ota_room not found'
      }
      return render json: response, status: 404
    end

    if @ota_room.update(ota_room_params)
      render json: {
        status: 'Success',
        message: '',
        ota_room: @ota_room.as_json(except: [
          :created_at,
          :updated_at
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update ota_room'
      }
      render json: response, status: 400
    end
  end

  # DELETE /api/v1/ota_rooms/1
  def destroy
    # 自分の施設以外だとリジェクト
    if current_user.id != @ota_room.room.user.id
      response = {
        status: 'NotFound',
        message: 'ota_room not found'
      }
      return render json: response, status: 404
    end

    @ota_room.destroy
    response = {
      status: 'Success',
      message: ''
    }
    render json: response, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ota_room
      @ota_room = OtaRoom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ota_room_params
      params.require(:ota_room).permit(:name, :stock_max, :overbooking_thresh, :price, :status, :facility_id)
    end
end
