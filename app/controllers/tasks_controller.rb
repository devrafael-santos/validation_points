class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:epic).order(priority: :desc)

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

  private

  def task_params
    params.expect(task: [ :stage ])
  end
end
