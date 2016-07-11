class QueryAssumptionResultsController < ApplicationController
  before_action :set_query_assumption_result, only: [:update]

  # PATCH/PUT /query_assumption_results/1
  # PATCH/PUT /query_assumption_results/1.json
  def update
    respond_to do |format|
      input = query_assumption_result_params[:result].to_s
      @parameter_ok = input == "true" || input == "false"
      if @parameter_ok && @query_assumption_result.update(query_assumption_result_params)
        @query_assumption_result=@query_assumption_result.reload
        format.js
      else
        format.js { render 'update_error' }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_query_assumption_result
    @query_assumption_result = QueryAssumptionResult.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def query_assumption_result_params
    params.require(:query_assumption_result).permit(:result)
  end
end
