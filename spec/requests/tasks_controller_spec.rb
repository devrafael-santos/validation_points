require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /index" do
    it "redirect to sign in page when user is not authenticated" do
      get root_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns success when user is authenticated" do
      sign_in users(:one)
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    it "redirect to sign in page when user is not authenticated" do
      task = tasks(:one)
      get task_path(task)

      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns success when user is authenticated" do
      sign_in users(:one)
      task = tasks(:one)
      get task_path(task)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /tasks/:id" do
    it "updates task stage" do
      sign_in users(:one)
      task = tasks(:one)

      patch task_path(task), params: { task: { stage: "code_review" } }
      expect(response).to have_http_status(:ok)
      expect(task.reload.stage).to eq("code_review")
    end
  end

  describe "PATCH /tasks/:id/toggle_reviewer" do
    it "adds reviewer" do
      user = users(:one)
      sign_in user
      task = tasks(:one)

      patch toggle_reviewer_task_path(task)
      expect(task.reload.reviewer).to eq(user)
    end

    it "removes reviewer" do
      user = users(:one)
      sign_in user
      task = tasks(:one)
      task.update!(reviewer: user)

      patch toggle_reviewer_task_path(task)
      expect(task.reload.reviewer).to be_nil
    end
  end
end
