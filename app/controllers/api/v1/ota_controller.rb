class Api::V1::OtaController < Api::V1::ApplicationController
  before_action :set_otum, only: [:show, :update, :destroy, :get_rooms, :get_bookings]
  before_action :authenticate_user!

  # GET /api/v1/ota
  # GET /api/v1/ota?facility=[facility_id]
  def index
    ota = Array.new
    if params[:facility].nil?
      # 自分の施設情報だけを返す
      facilities = current_user.facilities
      facilities.each do |facility|
        ota.concat(
          facility.ota.select do |otum|
            otum.provider != 'default'
          end
        )
      end
    else
      # facility=[facility_id]
      facility = Facility.find_by(id: params[:facility].to_i)
      # 施設IDが存在しない場合
      if facility.nil?
        response = {
          status: 'NotFound',
          message: 'ota not found'
        }
        return render json: response, status: 404
      end
      # ユーザーの施設IDでない場合
      if facility.user_id != current_user.id
        response = {
          status: 'NotFound',
          message: 'ota not found'
        }
        return render json: response, status: 404
      end

      ota.concat(
        facility.ota.select do |otum|
          otum.provider != 'default'
        end
      )
    end

    render json: {
      status: 'Success',
      message: '',
      ota: ota.as_json(except: [
        :password,
        :token,
        :created_at,
        :updated_at
      ], include: [
        :ota_rooms
      ])
    }, status: 200
  end

  # GET /api/v1/ota/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @otum.user.id
      response = {
        status: 'NotFound',
        message: 'ota not found'
      }
      return render json: response, status: 404
    end

    render json: {
      status: 'success',
      message: '',
      otum: @otum.as_json(except: [
        :password,
        :token,
        :created_at,
        :updated_at
      ], include: [
        :ota_rooms
      ])
    }, status: 200
  end

  # POST /api/v1/ota
  def create
    @otum = Otum.new(otum_params)

    # パスワードを暗号化
    @otum.set_encrypt_password(params[:otum][:password])

    if @otum.save
      # クロールスタート
      RakutenWorker.perform_async('room_and_booking', 'get', {
        otum: @otum
      })

      render json: {
        status: 'success',
        message: '',
        otum: @otum.as_json(except: [
          :password,
          :token,
          :created_at,
          :updated_at
        ], include: [
          :ota_rooms
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to create ota'
      }
      render json: response, status: 400
    end
  end

  # PATCH/PUT /api/v1/ota/1
  def update
    # 自分の施設以外だとリジェクト
    if current_user.id != @otum.user.id
      response = {
        status: 'NotFound',
        message: 'ota not found'
      }
      render json: response, status: 404
    end

    # パスワードを暗号化
    unless params[:otum][:password].nil?
      @otum.set_encrypt_password(params[:otum][:password])
    end

    if @otum.update(otum_params)
      render json: {
        status: 'success',
        message: '',
        ota: @otum.as_json(except: [
          :password,
          :token,
          :created_at,
          :updated_at
        ], include: [
          :ota_rooms
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update ota'
      }
      render json: response, status: 400
    end
  end

  # DELETE /api/v1/ota/1
  def destroy
    # 自分の施設以外だとリジェクト
    if current_user.id != @otum.user.id
      response = {
        status: 'NotFound',
        message: 'ota not found'
      }
      return render json: response, status: 404
    end

    @otum.destroy
    response = {
      status: 'success',
      message: ''
    }
    render json: response, status: 200
  end

  # OTAから部屋情報を取得
  def get_rooms
    RakutenWorker.perform_async('room', 'get', {
      otum: @otum
    })
    response = {
      status: 'Success',
      message: ''
    }
    render json: response, status: 200
  end

  # OTAから予約情報を取得
  def get_bookings
    RakutenWorker.perform_async('booking', 'get', {
      otum: @otum
    })
    response = {
      status: 'Success',
      message: ''
    }
    render json: response, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_otum
      @otum = Otum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def otum_params
      params.require(:otum).permit(:provider, :account, :password, :name, :facility_id)
    end
end
