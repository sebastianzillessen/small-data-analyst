class PreferencesController < ApplicationController
  before_action :set_preference, only: [:show, :edit, :update, :destroy]

  # GET /preferences
  # GET /preferences.json
  def index
    @preferences = Preference.order(:research_question_id, :stage).all.select { |p| can? :read, p }
  end

  # GET /preferences/1
  # GET /preferences/1.json
  def show
  end

  # GET /preferences/new
  def new
    @preference = Preference.new
    @preference.preference_arguments << PreferenceArgument.new if @preference.preference_arguments.empty?
  end

  # GET /preferences/1/edit
  def edit
  end

  # POST /preferences
  # POST /preferences.json
  def create
    @preference = Preference.new(preference_params)
    @preference.user = current_user
    respond_to do |format|
      if @preference.save
        format.html { redirect_to @preference, notice: 'Preference was successfully created.' }
        format.json { render :show, status: :created, location: @preference }
      else
        @preference.preference_arguments << PreferenceArgument.new if @preference.preference_arguments.empty?
        format.html { render :new }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /preferences/1
  # PATCH/PUT /preferences/1.json
  def update
    respond_to do |format|
      if @preference.update(preference_params)
        format.html { redirect_to @preference, notice: 'Preference was successfully updated.' }
        format.json { render :show, status: :ok, location: @preference }
      else
        @preference.preference_arguments << PreferenceArgument.new if @preference.preference_arguments.empty?
        format.html { render :edit }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.json
  def destroy
    @preference.destroy
    respond_to do |format|
      format.html { redirect_to preferences_url, notice: 'Preference was successfully destroyed.' }
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_preference
    @preference = Preference.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def preference_params
    attr = [
        :name, :research_question_id, :stage,
        preference_arguments_attributes: [
            :id, :assumption_id, :_destroy,
            :order_string
        ]
    ]
    if (can? :edit_global, @preference)
      attr << :global
    end
    params.require(:preference).permit(attr)
  end
end
