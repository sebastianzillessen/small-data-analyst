class AnalysesController < ApplicationController
  before_action :set_analysis, only: [:show, :edit, :update, :destroy]

  # GET /analyses
  # GET /analyses.json
  def index
    @analyses = Analysis.all.select { |a| can? :read, a }
  end

  # GET /analyses/1
  # GET /analyses/1.json
  def show
  end

  # GET /analyses/new
  def new
    @analysis = Analysis.new
  end

  # GET /analyses/1/edit
  def edit
  end

  # POST /analyses
  # POST /analyses.json
  def create
    @analysis = Analysis.new(analysis_params)

    respond_to do |format|
      if @analysis.save
        @analysis.start
        format.html { redirect_to @analysis, notice: 'Analysis was successfully created.' }
        format.json { render :show, status: :created, location: @analysis }
      else
        format.html { render :new }
        format.json { render json: @analysis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /analyses/1
  # PATCH/PUT /analyses/1.json
  def update
    respond_to do |format|
      if @analysis.update(analysis_params)
        format.html { redirect_to @analysis, notice: 'Analysis was successfully updated.' }
        format.json { render :show, status: :ok, location: @analysis }
      else
        format.html { render :edit }
        format.json { render json: @analysis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analyses/1
  # DELETE /analyses/1.json
  def destroy
    @analysis.destroy
    respond_to do |format|
      format.html { redirect_to analyses_url, notice: 'Analysis was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_analysis
    @analysis = Analysis.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def analysis_params
    res = params.require(:analysis).permit(:research_question_id, :dataset_id, query_assumption_results: [:result])
    res[:user] = current_user
    res
  end
end
