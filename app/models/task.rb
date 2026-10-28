class Task < ApplicationRecord
  before_save :clear_reviewer, if: :will_save_change_to_stage?
  after_update_commit -> { broadcast_refresh_to "tasks" }

  belongs_to :epic
  belongs_to :reviewer, class_name: "User", optional: true

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
  validates :jira_url, :pull_request_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }

  private

  def clear_reviewer
    self.reviewer = nil
  end
end
