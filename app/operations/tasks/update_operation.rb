module Tasks
  class UpdateOperation < ApplicationOperation
    def initialize(task:, params:)
      @task = task
      @params = params
    end

    def call
      if @task.update(@params)
        TaskMailer.task_completed(@task).deliver_later if @task.stage_production?
        success(@task)
      else
        failure(@task.errors.full_messages, @task)
      end
    end
  end
end
