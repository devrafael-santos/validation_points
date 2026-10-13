class Epic < ApplicationRecord
  has_many :tasks, dependent: :destroy

  enum :project_type, {
    backend: 0,
    frontend: 1,
    mobile: 2,
    fullstack: 3
  }, prefix: true

  validates :name, :jira_key, presence: true
  validates :jira_key, uniqueness: true
end
