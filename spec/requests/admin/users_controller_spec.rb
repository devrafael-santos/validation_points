require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  describe "GET /admin/users" do
    it "redirects to sign in page when user is not authenticated" do
      get admin_users_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects to root path when user is a member" do
      sign_in users(:two)
      get admin_users_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to access this section.")
    end

    it "returns success when user is an admin" do
      sign_in users(:one)
      get admin_users_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /admin/users/:id" do
    it "redirects to root path when user is a member" do
      sign_in users(:two)
      user = users(:one)

      patch admin_user_path(user), params: { user: { name: "New Name" } }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to access this section.")
    end

    it "updates user attributes when user is an admin" do
      sign_in users(:one)
      user = users(:two)

      patch admin_user_path(user), params: { user: { name: "New Name" } }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq("Usuário atualizado com sucesso.")
      expect(user.reload.name).to eq("New Name")
    end

    it "updates user role when user is an admin" do
      sign_in users(:one)
      user = users(:two)

      patch admin_user_path(user), params: { user: { role: "admin" } }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq("Usuário atualizado com sucesso.")
      expect(user.reload.role).to eq("admin")
    end

    it "prevents admin from demoting oneself" do
      sign_in users(:one)
      user = users(:one)

      patch admin_user_path(user), params: { user: { role: "member" } }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:alert]).to eq("Você não pode remover a si mesmo do grupo de administradores.")
      expect(user.reload.role).to eq("admin")
    end
  end

  describe "DELETE /admin/users/:id" do
    it "redirects to root path when user is a member" do
      sign_in users(:two)
      user = users(:one)

      delete admin_user_path(user)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to access this section.")
    end

    it "deletes user when user is an admin" do
      sign_in users(:one)
      user = users(:two)

      delete admin_user_path(user)

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq("Usuário excluído com sucesso.")
      expect(User.exists?(user.id)).to be false
    end

    it "prevents admin from deleting oneself" do
      sign_in users(:one)
      user = users(:one)

      delete admin_user_path(user)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Você não tem permissão para executar esta ação.")
      expect(User.exists?(user.id)).to be true
    end
  end
end
