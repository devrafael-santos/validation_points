require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    it "redirects to sign in page when user is not authenticated" do
      user = users(:one)
      get user_path(user)

      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns success when user is authenticated" do
      sign_in users(:one)
      user = users(:one)
      get user_path(user)

      expect(response).to have_http_status(:ok)
    end

    it "redirects with alert when member is authenticated but not the owner" do
      sign_in users(:two)
      user = users(:one)
      get user_path(user)

      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to eq("Você não tem permissão para executar esta ação.")
    end

    it "returns success when member is authenticated and is the owner" do
      sign_in users(:two)
      user = users(:two)
      get user_path(user)

      expect(response).to have_http_status(:ok)
    end

    it "returns success when admin is authenticated and is not the owner" do
      sign_in users(:one)
      user = users(:two)
      get user_path(user)

      expect(response).to have_http_status(:ok)
    end
  end
end
