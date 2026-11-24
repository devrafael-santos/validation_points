require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "user_created" do
    it "renders headers and body correctly" do
      user = users(:one)
      mail = UserMailer.user_created(user)

      expect(mail.subject).to eq("Bem-vindo ao Validation Points!")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
      expect(mail.body.encoded).to include(user.name)
      expect(mail.body.encoded).to include("Validation Points")
      expect(mail.body.encoded).to include("Acessar Minha Conta")
    end
  end
end
