class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviewing_tasks, class_name: "Task", foreign_key: :reviewer_id, dependent: :nullify
  has_one_attached :avatar

  validates :name, presence: true
  validate :acceptable_avatar

  enum :role, {
    member: 0,
    admin: 1
  }

  private

  def acceptable_avatar
    return unless avatar.attached?

    acceptable_types = %w[image/png image/jpeg image/jpg]
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, "deve ser uma imagem nos formatos PNG ou JPG")
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "é muito pesada (máximo permitido é 5MB)")
    end
  end
end
