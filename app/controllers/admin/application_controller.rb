class Admin::ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :authenticate_admin!

  private
    def authenticate_admin!
      if !current_user.admin_role?
        redirect_to new_admin_user_session_path, status: 404
      end
    end

  protected
    def authenticate_user!
      if user_signed_in?
        super
      else
        redirect_to new_admin_user_session_path, status: 401
      end
    end
end
