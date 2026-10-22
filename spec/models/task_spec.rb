require "rails_helper"

RSpec.describe Task, type: :model do
  context "when create a new task" do
    it "is invalid without a title" do
      task = tasks(:one)
      task.title = nil

      expect(task).not_to be_valid
    end
  end

  context "when update a task" do
    it "clears the reviewer when stage changes" do
      task = tasks(:one)
      task.update!(reviewer: users(:one))
      task.update!(stage: :code_review)

      expect(task.reviewer).to be_nil
    end

    it "keeps the reviewer when stage does not change" do
      task = tasks(:one)
      task.update!(reviewer: users(:one))
      task.update!(title: "New title")

      expect(task.reviewer).to eq(users(:one))
    end
  end
end
