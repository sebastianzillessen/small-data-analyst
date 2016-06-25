class ResearchQuestionsController < ApplicationController
  before_action :set_research_question, only: [:show, :edit, :update, :destroy]

  # GET /research_questions
  # GET /research_questions.json
  def index
    @research_questions = ResearchQuestion.all.select { |r| can? :read, r }
  end

  # GET /research_questions/1
  # GET /research_questions/1.json
  def show
  end

  # GET /research_questions/new
  def new
    @research_question = ResearchQuestion.new
  end

  # GET /research_questions/1/edit
  def edit
  end

  # POST /research_questions
  # POST /research_questions.json
  def create
    @research_question = ResearchQuestion.new(research_question_params)

    respond_to do |format|
      if @research_question.save
        format.html { redirect_to @research_question, notice: 'Research question was successfully created.' }
        format.json { render :show, status: :created, location: @research_question }
      else
        format.html { render :new }
        format.json { render json: @research_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /research_questions/1
  # PATCH/PUT /research_questions/1.json
  def update
    respond_to do |format|
      if @research_question.update(research_question_params)
        format.html { redirect_to @research_question, notice: 'Research question was successfully updated.' }
        format.json { render :show, status: :ok, location: @research_question }
      else
        format.html { render :edit }
        format.json { render json: @research_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /research_questions/1
  # DELETE /research_questions/1.json
  def destroy
    @research_question.destroy
    respond_to do |format|
      format.html { redirect_to research_questions_url, notice: 'Research question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_research_question
    @research_question = ResearchQuestion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def research_question_params
    res = params.require(:research_question).permit(:name, :description, :private, :model_ids => [])
    res[:user] = current_user
    res
  end
end
