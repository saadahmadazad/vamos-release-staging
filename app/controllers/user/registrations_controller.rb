# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { action_name == 'create' }

  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save

    render json: 'ok'
  end

  protected


  def sign_up_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :role)
  end

end
