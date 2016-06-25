module Admin
  class AdminController < ApplicationController
    before_filter :verify_admin

    def index

    end

    private
    def verify_admin
      redirect_to root_url, alert: "You do not have enough rights to access this page." unless current_user.try(:is_admin?)
    end

  end
end
