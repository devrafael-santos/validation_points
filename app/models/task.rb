class Task < ApplicationRecord
  belongs_to :epic

  enum :stage, {
    to_do: 0,
    blocked: 1,
    in_progress: 2,
    adjustment: 3,
    local_validation: 4,
    internal_review: 5,
    code_review: 6,
    ready_to_stage: 7,
    staging: 8,
    ready_to_deploy: 9,
    production: 10
  }, prefix: true

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2,
    urgent: 3
  }, prefix: true

  validates :title, :jira_key, presence: true
  validates :jira_key, uniqueness: true
end
