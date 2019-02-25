class ApplicationController < ActionController::Base
  before_action :permit_more_parameters, if: :devise_controller?


  protected

  def permit_more_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
