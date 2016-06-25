class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_load_and_authorize_resource

  def index
  end
end
