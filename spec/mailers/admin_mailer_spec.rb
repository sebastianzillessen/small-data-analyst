require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "new_user_waiting_for_approval" do
    let!(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let(:mail) { AdminMailer.new_user_waiting_for_approval(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("New user waiting for approval")
      expect(mail.to).to eq([admin.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("User waiting for approval on")
    end
  end

end
