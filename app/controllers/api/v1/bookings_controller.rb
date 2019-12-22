class Api::V1::BookingsController < Api::V1::ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /api/v1/bookings
  # GET /api/v1/bookings?year={:year}&month={:month}
  def index
    bookings = Array.new

    if params[:year].nil? || params[:month].nil?
      # パラメータが不足している場合は全て返す
      current_user.ota.each do |otum|
        bookings.concat(otum.bookings)
      end
    else
      year = params[:year].to_i
      month = params[:month].to_i

      # 不正な引数の場合
      if year == 0 || month == 0
        response = {
          status: 'BadRequest',
          message: 'invalid params'
        }
        return render json: response, status: 400
      end

      # 配列を結合
      date_from = Date.new(year, month, 1)
      date_to = Date.new(year, month + 1, 1)
      current_user.ota.each do |otum|
        bookings.concat(
          otum.bookings.select do |booking|
            booking.checkin < date_to && booking.checkout >= date_from
          end
        )
      end
    end

    render json: {
      status: 'Success',
      message: '',
      bookings: bookings.as_json(except: [
        :created_at,
        :updated_at
      ], include: [
        room: {
          include: [
            facility: {
              except: [
                :stripe_subscription_id
              ]
            }
          ]
        },
        otum: {
          except: [
            :password,
            :token,
            :created_at,
            :updated_at
          ], include: [
            facility: {
              except: [
                :stripe_subscription_id
              ]
            }
          ]
        }
      ])
    }, status: 200
  end

  # GET /api/v1/bookings/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @booking.otum.user.id
      response = {
        status: 'NotFound',
        message: 'booking not found'
      }
      return render json: response, status: 404
    end

    render json: {
      status: 'Success',
      message: '',
      booking: @booking.as_json(except: [
        :created_at,
        :updated_at
      ], include: [
        room: {
          include: [
            facility: {
              except: [
                :stripe_subscription_id
              ]
            }
          ]
        },
        otum: {
          except: [
            :password,
            :token,
            :created_at,
            :updated_at
          ], include: [
            facility: {
              except: [
                :stripe_subscription_id
              ]
            }
          ]
        }
      ])
    }, status: 200
  end

  # POST /api/v1/bookings
  def create
    ota_room = nil
    if(params['booking']['room_id'])
      room = Room.find_by(id: params['booking']['room_id'].to_i)
      if room && room.facility
        otum = room.facility.ota.select do |otum|
          otum.provider == 'default'
        end
        if otum.blank?
          response = {
            status: 'BadRequest',
            message: 'ota id is not exists'
          }
          return render json: response, status: 400
        end
        ota_room = otum[0].ota_rooms.select do |ota_room|
          ota_room.room.id == room.id
        end
        if ota_room.blank?
          response = {
            status: 'BadRequest',
            message: 'ota room id is not exists'
          }
          return render json: response, status: 400
        end
        params['booking']['ota_room_id'] = ota_room[0].id
      else
        response = {
          status: 'BadRequest',
          message: 'room id is not exists'
        }
        return render json: response, status: 400
      end
    else
      response = {
        status: 'BadRequest',
        message: 'room id is not exists'
      }
      return render json: response, status: 400
    end

    @booking = Booking.new(booking_params)

    # OtaRoomの所有者チェック
    ota_room = OtaRoom.find(@booking.ota_room_id)
    if ota_room.otum.user.id != current_user.id
      response = {
        status: 'BadRequest',
        message: 'fail to create booking'
      }
      return render json: response, status: 400
    end

    # ブロックされていないかをチェック
    blocked_booking = Array.new
    current_user.ota.each do |otum|
      blocked_booking.concat(
        otum.bookings.select do |booking|
          booking.checkin < @booking.checkout && booking.checkout >= @booking.checkin && booking.is_blocked
        end
      )
    end
    unless blocked_booking.blank?
      response = {
        status: 'BadRequest',
        message: 'blocked schedule'
      }
      return render json: response, status: 400
    end

    if @booking.save
      render json: {
        status: 'Success',
        message: '',
        booking: @booking.as_json(except: [
          :created_at,
          :updated_at
        ], include: [
          room: {
            include: [
              facility: {
                except: [
                  :stripe_subscription_id
                ]
              }
            ]
          },
          otum: {
            except: [
              :password,
              :token,
              :created_at,
              :updated_at
            ], include: [
              facility: {
                except: [
                  :stripe_subscription_id
                ]
              }
            ]
          }
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to create booking'
      }
      render json: response, status: 400
    end
  end

  # PATCH/PUT /api/v1/bookings/1
  def update
    # 自分の施設以外だとリジェクト
    if current_user.id != @booking.otum.user.id
      response = {
        status: 'NotFound',
        message: 'booking not found'
      }
      return render json: response, status: 404
    end

    # ブロックされていないかをチェック
    blocked_booking = Array.new
    current_user.ota.each do |otum|
      blocked_booking.concat(
        otum.bookings.select do |booking|
          booking.checkin < @booking.checkout && booking.checkout >= @booking.checkin && booking.is_blocked
        end
      )
    end
    unless blocked_booking.blank?
      response = {
        status: 'BadRequest',
        message: 'blocked schedule'
      }
      return render json: response, status: 400
    end

    if @booking.update(booking_params)
      render json: {
        status: 'Success',
        message: '',
        booking: @booking.as_json(except: [
          :created_at,
          :updated_at
        ], include: [
          room: {
            include: [
              facility: {
                except: [
                  :stripe_subscription_id
                ]
              }
            ]
          },
          otum: {
            except: [
              :password,
              :token,
              :created_at,
              :updated_at
            ], include: [
              facility: {
                except: [
                  :stripe_subscription_id
                ]
              }
            ]
          }
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update booking'
      }
      render json: response, status: 400
    end
  end

  # DELETE /api/v1/bookings/1
  def destroy
    # 自分の施設以外だとリジェクト
    if current_user.id != @booking.otum.user.id
      response = {
        status: 'NotFound',
        message: 'booking not found'
      }
      return render json: response, status: 404
    end

    @booking.destroy
    response = {
      status: 'Success',
      message: ''
    }
    render json: response, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:uid, :status, :checkin, :checkout, :count_room, :price, :price_balance, :price_total, :subscriber_name, :subscriber_kana, :subscriber_tel, :subscriber_email, :subscriber_address, :booking_date, :guest_name, :guest_kana, :payment_method, :number_total, :number_males, :number_females, :number_adults, :number_children, :currency, :ota_room_id, :comment, :is_blocked)
    end
end
