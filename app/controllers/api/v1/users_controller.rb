class Api::V1::UsersController < Api::V1::ApplicationController
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:show, :update, :destroy]

  # GET /api/v1/users/1
  def show
    # 自分の施設以外だとリジェクト
    if current_user.id != @user.id
      response = {
        status: 'NotFound',
        message: 'user not found'
      }
      return render json: response, status: 404
    end


    # baka: @user.update_billing_status (
    @user.update_billing_status

    render json: {
      status: 'Success',
      message: '',
      user: @user.as_json(except: [
        :encrypted_password,
        :reset_password_token,
        :reset_password_sent_at,
        :remember_created_at,
        :confirmation_token,
        :stripe_uid,
        :created_at,
        :updated_at
      ]),
    }, status: 200
  end

  # PATCH/PUT /api/v1/users/1
  def update
    # 自分以外だとリジェクト
    if current_user.id != @user.id
      response = {
        status: 'NotFound',
        message: 'user not found'
      }
      return render json: response, status: 404
    end

    if @user.update(user_params)
      render json: {
        status: 'Success',
        message: '',
        user: @user.as_json(except: [
          :encrypted_password,
          :reset_password_token,
          :reset_password_sent_at,
          :remember_created_at,
          :confirmation_token,
          :stripe_uid,
          :created_at,
          :updated_at
        ])
      }, status: 201
    else
      response = {
        status: 'BadRequest',
        message: 'fail to update user'
      }
      render json: resopnse, status: 400
    end
  end

  # DELETE /api/v1/users/1
  def destroy
    # 自分以外だとリジェクト
    if current_user.id != @user.id
      response = {
        status: 'NotFound',
        message: 'user not found'
      }
      return render json: response, status: 404
    end

    @user.destroy
    resopnse = {
      status: 'Success',
      message: ''
    }
    render json: response, status: 200
  end

  # Get /api/v1/users/current_user
  def current
    @user = current_user
    render json: {
      status: 'Success',
      message: '',
      user: @user.as_json(except: [
        :encrypted_password,
        :reset_password_token,
        :reset_password_sent_at,
        :remember_created_at,
        :confirmation_token,
        :stripe_uid,
        :created_at,
        :updated_at
      ])
    }, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name)
    end
end
