class TasksController < ApplicationController
  def index
    @tasks = Task.stage_internal_review.includes(:epic).order(priority: :desc)

    if params[:project_type].present?
      @tasks = @tasks.joins(:epic).where(epics: { project_type: params[:project_type] })
    end

    @total_count = @tasks.count
    @urgent_count = @tasks.priority_urgent.count
  end

  def show
    @task = Task.find(params[:id])
  end
end
