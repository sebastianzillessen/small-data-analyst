require 'r_script_execution'

class RScriptsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_load_and_authorize_resource

  def plot
    @assumption = Assumption.where(id: params[:assumption_id]).first if params[:assumption_id]
    @dataset = params[:dataset_id] && Dataset.where(id: params[:dataset_id]).first
    if @assumption && @dataset
      @plot = @assumption.graph(@dataset)
    end
  rescue Exception => e
    @error = e.message
  end

  def validate
    @script = params[:r_script]
    @assumption_type = params[:assumption_type].constantize
    @dataset = params[:dataset_id] && Dataset.where(id: params[:dataset_id]).first

    if (@script.present?)
      begin
        if @assumption_type == TestAssumption
          @result = RScriptExecution.execute(@script, @dataset.try(:data))
        elsif @assumption_type == QueryTestAssumption
          filename = File.join(Plot::BASE_URL, "r_plot_#{SecureRandom.hex(10)}.png")
          @result = RScriptExecution.retrieveFile(@script, @dataset.try(:data), filename)
          if @result
            @plot = Plot.new(filename: filename)
            Delayed::Job.enqueue(FileDeleterJob.new(filename), run_at: 5.minutes.from_now)
          end
        else
          raise RuntimeException, "The transferred assumption type did not match."
        end
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
