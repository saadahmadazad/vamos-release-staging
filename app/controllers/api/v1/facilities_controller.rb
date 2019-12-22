class Api::V1::FacilitiesController < Api::V1::ApplicationController
  before_action :set_facility, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /api/v1/facilities
  def index
    # 自分の施設情報だけを返す
    @facilities = current_user.facilities

    render json: {
      status: 'success',
      message: '',
      facilities: @facilities.as_json(except: [
        :stripe_subscription_id
      ], include: [
        user: {
          except: [
            :role,
            :encrypted_password,
            :reset_password_token,
            :reset_password_sent_at,
            :remember_created_at,
            :confirmation_token,
            :stripe_uid,
            :created_at,
            :updated_at
          ]
        }
      ])
    }, status: 200
  end

  # GET /api/v1/facilities/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @facility.user.id
      response = {
        status: 'NotFound',
        message: 'facility not found'
      }
      return render json: response, status: 404
    end

    render json: {
      status: 'success',
      message: '',
      facility: @facility.as_json(except: [
        :stripe_subscription_id
      ], include: [
        user: {
          except: [
            :role,
            :encrypted_password,
            :reset_password_token,
            :reset_password_sent_at,
            :remember_created_at,
            :confirmation_token,
            :stripe_uid,
            :created_at,
            :updated_at
          ]
        }
      ])
    }, status: 200
  end

  # POST /api/v1/facilities
  def create
    @facility = Facility.new(facility_params)
    @facility.user = current_user

    if @facility.save

      render json: {
        status: 'success',
        message: '',
        facility: @facility.as_json(except: [
          :stripe_subscription_id
        ], include: [
          user: {
            except: [
              :role,
              :encrypted_password,
              :reset_password_token,
              :reset_password_sent_at,
              :remember_created_at,
              :confirmation_token,
              :stripe_uid,
              :created_at,
              :updated_at
            ]
          }
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to create facility'
      }
      render json: response, status: 400
    end
  end

  # PATCH/PUT /api/v1/facilities/1
  def update
    # 自分の施設以外だとリジェクト
    if current_user.id != @facility.user.id
      response = {
        status: 'NotFound',
        message: 'facility not found'
      }
      return render json: response, status: 404
    end

    if @facility.update(facility_params)
      response = {
        status: 'success',
        message: 'ok',
        facility: @facility
      }
      render json: {
        status: 'Success',
        message: '',
        facility: @facility.as_json(except: [
          :stripe_subscription_id
        ], include: [
          user: {
            except: [
              :role,
              :encrypted_password,
              :reset_password_token,
              :reset_password_sent_at,
              :remember_created_at,
              :confirmation_token,
              :stripe_uid,
              :created_at,
              :updated_at
            ]
          }
        ])
      }, status: 200
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update facility'
      }
      render json: response, status: 400
    end
  end

  # DELETE /api/v1/facilities/1
  def destroy
    # 自分の施設以外だとリジェクト
    if current_user.id != @facility.user.id
      response = {
        status: 'NotFound',
        message: 'facility not found'
      }
      return render json: response, status: 404
    end

    @facility.destroy
    response = {
      status: 'success',
      message: '削除しました'
    }
    render json: response, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_params
      params.require(:facility).permit(:name, :location, :user_id)
    end
end
