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

  def new
    @task = Task.new
    @epics = Epic.all
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path, notice: "Task was successfully created."
    else
      @epics = Epic.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Task was successfully updated." }
        format.json { head :ok }
      end
    else
      @epics = Epic.all
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
    @epics = Epic.all
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_path, status: :see_other, notice: "Task was successfully deleted."
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
    params.expect(task: [ :stage, :title, :jira_key, :jira_url, :pull_request_url, :priority, :epic_id, :description ])
  end
end
