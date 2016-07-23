class AssumptionsController < ApplicationController
  before_action :set_assumption, only: [:show, :edit, :update, :destroy]

  # GET /assumptions
  # GET /assumptions.json
  def index
    @assumptions = Assumption.all.select { |a| can? :read, a }
  end

  # GET /assumptions/1
  # GET /assumptions/1.json
  def show
  end

  # GET /assumptions/new
  def new
    @assumption = Assumption.new()
    if (params[:assumption] && type = params[:assumption][:type])
      @assumption = @assumption.becomes!(type.constantize)
    end
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
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_assumption
    @assumption = Assumption.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assumption_params
    attribute_for_all = [:name, :description, :type,]
    array_for_all = {required_by_ids: [], model_ids: []}
    res = if (params[:query_assumption])
            params.require(:query_assumption).permit(attribute_for_all, :question, :argument_inverted, array_for_all)
          elsif (params[:blank_assumption])
            params.require(:blank_assumption).permit(attribute_for_all, :argument_inverted, array_for_all, assumption_ids: [])
          elsif (params[:test_assumption])
            params.require(:test_assumption).permit(attribute_for_all, :r_code, :argument_inverted, array_for_all, required_dataset_fields: [])
          elsif (params[:query_test_assumption])
            params.require(:query_test_assumption).permit(attribute_for_all, :r_code, :argument_inverted, :question, :argument_inverted, array_for_all, required_dataset_fields: [])
          else
            {}
          end
    res[:user] = current_user
    res
  end
end
