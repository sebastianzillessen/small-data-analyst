require 'r_script_execution'

class RScriptsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_load_and_authorize_resource

  def validate
    @script = params[:r_script]
    @dataset = params[:dataset_id] && Dataset.where(id: params[:dataset_id]).first
    if (@script.present?)
      begin
        @result = RScriptExecution.execute(@script, @dataset.try(:data))
      rescue Exception => e
        @error = e
      end
    else
      @error = "The script was empty. Please provide a script"
    end
    respond_to do |format|
      format.html { render :validate, status: @error ? :wrong_request : :ok }
      format.js
    end

  end
end
