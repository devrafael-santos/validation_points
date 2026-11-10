class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  allow_browser versions: :modern

  stale_when_importmap_changes

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar ])
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = "Você não tem permissão para executar esta ação."
        redirect_back(fallback_location: root_path)
      end
      format.json do
        render json: { error: "Você não tem permissão para executar esta ação." }, status: :forbidden
      end
    end
  end
end
