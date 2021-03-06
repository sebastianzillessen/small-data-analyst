require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ResearchQuestionsController, type: :controller do
  login_statistician
  # This should return the minimal set of attributes required to create a valid
  # ResearchQuestion. As you add validations to ResearchQuestion, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    build(:research_question).attributes
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ResearchQuestionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let!(:research_question) { create(:research_question) }
  subject { research_question }

  describe "GET #index" do
    it "assigns all research_questions as @research_questions" do
      get :index, {}, valid_session
      expect(assigns(:research_questions)).to eq([research_question])
    end
  end

  describe "GET #show" do
    it "assigns the requested research_question as @research_question" do
      get :show, {:id => research_question.to_param}, valid_session
      expect(assigns(:research_question)).to eq(research_question)
    end
  end

  describe "GET #new" do
    it "assigns a new research_question as @research_question" do
      get :new, {}, valid_session
      expect(assigns(:research_question)).to be_a_new(ResearchQuestion)
    end
  end

  describe "GET #edit" do
    it "assigns the requested research_question as @research_question" do
      get :edit, {:id => research_question.to_param}, valid_session
      expect(assigns(:research_question)).to eq(research_question)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ResearchQuestion" do
        expect {
          post :create, {:research_question => valid_attributes}, valid_session
        }.to change(ResearchQuestion, :count).by(1)
      end

      it "assigns a newly created research_question as @research_question" do
        post :create, {:research_question => valid_attributes}, valid_session
        expect(assigns(:research_question)).to be_a(ResearchQuestion)
        expect(assigns(:research_question)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved research_question as @research_question" do
        post :create, {:research_question => invalid_attributes}, valid_session
        expect(assigns(:research_question)).to be_a_new(ResearchQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, {:research_question => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: "Test"}
      }

      it "updates the requested research_question" do
        put :update, {:id => research_question.to_param, :research_question => new_attributes}, valid_session
        research_question.reload
        expect(research_question.name).to eq ("Test")
      end

      it "assigns the requested research_question as @research_question" do
        put :update, {:id => research_question.to_param, :research_question => valid_attributes}, valid_session
        expect(assigns(:research_question)).to eq(research_question)
      end

      it "redirects to the research_question" do
        put :update, {:id => research_question.to_param, :research_question => valid_attributes}, valid_session
        expect(response).to redirect_to(research_question)
      end
    end

    context "with invalid params" do
      it "assigns the research_question as @research_question" do
        put :update, {:id => research_question.to_param, :research_question => invalid_attributes}, valid_session
        expect(assigns(:research_question)).to eq(research_question)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => research_question.to_param, :research_question => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested research_question" do
      expect {
        delete :destroy, {:id => research_question.to_param}, valid_session
      }.to change(ResearchQuestion, :count).by(-1)
    end

    it "redirects to the research_questions list" do
      delete :destroy, {:id => research_question.to_param}, valid_session
      expect(response).to redirect_to(research_questions_url)
    end
  end

end
