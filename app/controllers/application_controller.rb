class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # authenticate devise
  before_action :authenticate_user!
  # check for abilities
  load_and_authorize_resource :unless => :devise_controller?

  protected


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to request.referrer || root_url, :alert => exception.message }
    end
  end
end
