module Tasks
  class ToggleReviewerOperation < ApplicationOperation
    def initialize(task:, user:)
      @task = task
      @user = user
    end

    def call
      if @task.reviewer == @user
        remove_reviewer
      else
        assign_reviewer
      end
    end

    private

    def remove_reviewer
      if @task.update(reviewer: nil)
        success(@task)
      else
        failure(@task.errors.full_messages, @task)
      end
    end

    def assign_reviewer
      if @task.update(reviewer: @user)
        TaskMailer.reviewer_assigned(@task).deliver_later
        success(@task)
      else
        failure(@task.errors.full_messages, @task)
      end
    end
  end
end
