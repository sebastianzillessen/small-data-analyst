class AssumptionsController < ApplicationController
  before_action :set_assumption, only: [:show, :edit, :update, :destroy]

  # GET /assumptions
  # GET /assumptions.json
  def index
    @assumptions = Assumption.all
  end

  # GET /assumptions/1
  # GET /assumptions/1.json
  def show
  end

  # GET /assumptions/new
  def new
    @assumption = Assumption.new
  end

  # GET /assumptions/1/edit
  def edit
  end

  # POST /assumptions
  # POST /assumptions.json
  def create
    @assumption = Assumption.new(assumption_params)

    respond_to do |format|
      if @assumption.save
        format.html { redirect_to @assumption.becomes(Assumption), notice: 'Assumption was successfully created.' }
        format.json { render :show, status: :created, location: @assumption.becomes(Assumption) }
      else
        format.html { render :new }
        format.json { render json: @assumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assumptions/1
  # PATCH/PUT /assumptions/1.json
  def update
    respond_to do |format|
      if @assumption.update(assumption_params)
        format.html { redirect_to @assumption.becomes(Assumption), notice: 'Assumption was successfully updated.' }
        format.json { render :show, status: :ok, location: @assumption.becomes(Assumption) }
      else
        format.html { render :edit }
        format.json { render json: @assumption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assumptions/1
  # DELETE /assumptions/1.json
  def destroy
    @assumption.destroy
    respond_to do |format|
      format.html { redirect_to assumptions_url, notice: 'Assumption was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_assumption
    @assumption = Assumption.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assumption_params
    if (params[:query_assumption])
      params.require(:query_assumption).permit(:name, :description, :critical, :type, :question, :argument_inverted)
    elsif (params[:blank_assumption])
      params.require(:blank_assumption).permit(:name, :description, :critical, :type, :argument_inverted)
    elsif (params[:test_assumption])
      params.require(:test_assumption).permit(:name, :description, :critical, :type, :fail_on_missing, :r_code, :argument_inverted, required_dataset_fields: [])
    else
      []
    end
  end
end
