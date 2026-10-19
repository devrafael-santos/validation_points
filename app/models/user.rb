class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviewing_tasks, class_name: "Task", foreign_key: :reviewer_id, dependent: :nullify

  validates :name, presence: true
end
