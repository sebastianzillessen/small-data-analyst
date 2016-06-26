class ConfirmationsController < Devise::ConfirmationsController

  def show
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    resource.assign_attributes(permitted_params) unless params[resource_name].nil?

    if resource.valid? && resource.password_match?
      resource.confirm!
      set_flash_message :notice, :confirmed
      sign_in_and_redirect resource_name, resource
    else
      render :action => 'show'
    end
  end

  private
  def permitted_params
    params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
  end

  def resource
    @resource ||= begin
      if params[:confirmation_token].present?
        @original_token = params[:confirmation_token]
      elsif params[resource_name].try(:[], :confirmation_token).present?
        @original_token = params[resource_name][:confirmation_token]
      end

      resource = resource_class.find_first_by_auth_conditions(confirmation_token: @original_token)
      unless resource
        confirmation_digest = Devise.token_generator.digest(self, :confirmation_token, @original_token)
        resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, confirmation_digest)
      end
      resource
    end

  end
end