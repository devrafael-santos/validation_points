require "rails_helper"

RSpec.describe User, type: :model do
  describe "roles" do
    it "identifies member correctly" do
      user = users(:two)

      expect(user.member?).to be true
      expect(user.admin?).to be false
    end

    it "identifies admin correctly" do
      user = users(:one)

      expect(user.member?).to be false
      expect(user.admin?).to be true
    end
  end

  describe "when creating a new user" do
    it "is valid with valid attributes" do
      user = users(:one)
      user.avatar.attach(io: StringIO.new("content"), filename: "avatar.png", content_type: "image/png")

      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = users(:one)
      user.name = nil

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("não pode ficar em branco")
    end

    it "is invalid with an avatar that is not an image" do
      user = users(:one)
      user.avatar.attach(io: StringIO.new("content"), filename: "avatar.pdf", content_type: "application/pdf")

      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include("deve ser uma imagem nos formatos PNG ou JPG")
    end

    it "is invalid with an avatar that is too large" do
      user = users(:one)
      user.avatar.attach(io: StringIO.new("a" * 6.megabytes), filename: "large.png", content_type: "image/png")

      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include("é muito pesada (máximo permitido é 5MB)")
    end
  end

  describe "when updating a user" do
    it "is valid with valid attributes" do
      user = users(:one)
      user.name = "New name"

      expect(user).to be_valid
    end
  end
end
