module Tasks
  class UrgentAlertJob < ApplicationJob
    queue_as :critical

    def perform(task_id)
      task = Task.find_by(id: task_id)
      return unless task&.priority_urgent?

      Rails.logger.warn("[URGENT ALERT] Task [#{task.jira_key}] '#{task.title}' requires immediate attention!")
    end
  end
end
