require "rails_helper"

RSpec.describe "Passwords", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "GET /users/password/new" do
    it "returns success" do
      get new_user_password_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users/password" do
    it "sends reset password instructions email when email exists" do
      user = users(:one)

      expect {
        post user_password_path, params: { user: { email: user.email } }
      }.to change { ActionMailer::Base.deliveries.size }.by(1)

      expect(response).to redirect_to(new_user_session_path)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([ user.email ])
      expect(mail.body.encoded).to include("reset_password_token=")
      expect(mail.body.encoded).to include("Criar Nova Senha")
    end

    it "does not send email when email does not exist" do
      expect {
        post user_password_path, params: { user: { email: "nonexistent@example.com" } }
      }.not_to change { ActionMailer::Base.deliveries.size }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("não foi encontrado")
    end
  end

  describe "GET /users/password/edit" do
    it "returns success with a valid reset password token" do
      raw_token = users(:one).send_reset_password_instructions

      get edit_user_password_path(reset_password_token: raw_token)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /users/password" do
    it "resets password with valid token and matching passwords" do
      user = users(:one)
      raw_token = user.send_reset_password_instructions

      put user_password_path, params: {
        user: {
          reset_password_token: raw_token,
          password: "newpassword123",
          password_confirmation: "newpassword123"
        }
      }

      expect(response).to redirect_to(root_path)
      expect(user.reload.valid_password?("newpassword123")).to be true
    end

    it "fails to reset password when token is expired" do
      user = users(:one)
      raw_token = user.send_reset_password_instructions

      travel 15.minutes do
        put user_password_path, params: {
          user: {
            reset_password_token: raw_token,
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(user.reload.valid_password?("newpassword123")).to be false
      end
    end
  end
end
