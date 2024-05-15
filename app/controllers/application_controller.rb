class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :profile_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :profile_image])
  end
end
