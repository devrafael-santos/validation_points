class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:epic, :reviewer).order(priority: :desc)

    if params[:project_type].present?
      @tasks = @tasks.joins(:epic).where(epics: { project_type: params[:project_type] })
    end

    @stages = Task.stages.keys
    @project_types = Epic.project_types
    @tasks_by_stage = @tasks.group_by(&:stage)
    @total_count = @tasks.count
    @urgent_count = @tasks.priority_urgent.count
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def toggle_reviewer
    @task = Task.find(params[:id])

    if @task.reviewer == current_user
      @task.update(reviewer: nil)
    else
      @task.update(reviewer: current_user)
    end

    redirect_to root_path
  end

  private

  def task_params
    params.expect(task: [ :stage ])
  end
end
