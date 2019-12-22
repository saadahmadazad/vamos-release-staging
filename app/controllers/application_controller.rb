class ApplicationController < ActionController::Base
	# protect_from_forgery prepend: true
	protect_from_forgery with: :null_session
	# def index
	#   render template: 'application/index'
	# end

  def after_sign_in_path_for(resource)
    admin_dashboard_path
	end
end
