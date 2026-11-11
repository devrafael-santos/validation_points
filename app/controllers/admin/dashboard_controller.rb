module Admin
  class DashboardController < Admin::BaseController
  def index
    @total_tasks = Task.count
    @completed_tasks_count = Task.where(stage: :production).count
    @active_reviews_count = Task.where(stage: :review).count
    @total_users_count = User.count
    @reviewer_count = User.joins(:reviewing_tasks).distinct.count

    @recent_completed_tasks = Task.where(stage: :production).order(updated_at: :desc).limit(5)
    @tasks_by_stage = Task.group(:stage).count
  end
  end
end
