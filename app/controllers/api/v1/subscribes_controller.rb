class Api::V1::SubscribesController < Api::V1::ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /api/v1/subscribe
  def show
    last_four = current_user.get_card_last_four

    render json: {
      status: 'success',
      message: '',
      card: {
        last_four: last_four,
      }
    }, status: 200
  end

  # POST /api/v1/subscribe
  def create
    # Stripe
    if params[:payment].nil? || params[:payment][:token].nil?
      # tokenがパラメータにない場合
      response = {
        status: 'BadRequest',
        message: 'invalid request'
      }
      return render json: response, status: 400
    end
    token = params[:payment][:token]
    # TODO: error handling
    current_user.update_card_info( token )

    current_user.facilities.each do |f|
      unless f.create_subscription
        response = {
          status: 'BadRequest',
          message: 'fail to create facility'
        }
        render json: response, status: 400
      end
    end

    render json: {
      status: 'success',
      message: '',
    }, status: 201
  end

  # PATCH/PUT /api/v1/subscribe
  def update
    # Stripe
    if params[:payment].nil? || params[:payment][:token].nil?
      # tokenがパラメータにない場合
      response = {
        status: 'BadRequest',
        message: 'invalid request'
      }
      return render json: response, status: 400
    end
    token = params[:payment][:token]
    # TODO: error handling
    current_user.update_card_info( token )

    render json: {
      status: 'Success',
      message: '',
    }, status: 200
  end
end