class Api::V1::ApplicationController < Api::ApplicationController
  protect_from_forgery with: :null_session
end
