class Api::V1::NotificationsController < Api::V1::ApplicationController
  before_action :set_notification, only: [:show, :update]
  before_action :authenticate_user!

  # GET /api/v1/notifications
  # GET /api/v1/notifications?unread=[0 or 1]
  def index
    notifications = params[:unread].nil? || params[:unread] == 0 ? current_user.notifications : Notification.where(user: current_user, status: :unread).all

    render json: {
      status: 'Success',
      message: '',
      notifications: notifications.as_json(except: [
        :created_at,
        :updated_at
      ])
    }, status: 200
  end

  # GET /api/v1/notifications/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @notification.user.id
      response = {
        status: 'NotFound',
        message: 'notification not found'
      }
      return render json: response, status: 404
    end

    render json: {
      status: 'Success',
      message: '',
      notification: @notification.as_json(except: [
        :created_at,
        :updated_at
      ])
    }, status: 200
  end

  # PATCH/PUT /api/v1/notifications/1
  def update
    # 自分の施設以外だとリジェクト
    if current_user.id != @notification.user.id
      response = {
        status: 'NotFound',
        message: 'notification not found'
      }
      return render json: response, status: 404
    end

    if @notification.update(notification_params)
      render json: {
        status: 'Success',
        message: '',
        notification: @notification.as_json(except: [
          :created_at,
          :updated_at
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update notification'
      }
      render json: response, status: 400
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:status)
    end
end
