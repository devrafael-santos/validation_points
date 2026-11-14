require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  describe "GET /admin" do
    it "redirects to sign in page when user is not authenticated" do
      get admin_root_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects to root path when user is a member" do
      sign_in users(:two)
      get admin_root_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to access this section.")
    end

    it "returns success when user is an admin" do
      sign_in users(:one)
      get admin_root_path

      expect(response).to have_http_status(:ok)
    end
  end
end
