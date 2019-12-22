class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # def render_resource(resource)
  #   if resource.errors.empty?
  #     render json: resource
  #   else
  #     validation_error(resource)
  #   end
  # end

  # def validation_error(resource)
  #   render json: {
  #     errors: [
  #       {
  #         status: '400',
  #         title: 'Bad Request',
  #         detail: resource.errors,
  #         code: '100'
  #       }
  #     ]
  #   }, status: :bad_request
  # end

  # protected
  # # 認証設定
  # def authenticate_any!
  #   if user_signed_in?
  #     true
  #   else
  #     authenticate_user!
  #   end
  # end
end
