require "rails_helper"

RSpec.describe Tasks::UpdateOperation do
  let(:task) { tasks(:one) }

  describe ".call" do
    context "when params are valid and stage is updated to production" do
      it "updates the task and enqueues task_completed email" do
        expect {
          result = described_class.call(task: task, params: { stage: "production" })

          expect(result.success?).to be true
          expect(result.data).to eq(task)
          expect(task.reload.stage).to eq("production")
        }.to have_enqueued_mail(TaskMailer, :task_completed).with(task)
      end
    end

    context "when params are valid and stage is not production" do
      it "updates the task and does not enqueue task_completed email" do
        expect {
          result = described_class.call(task: task, params: { title: "Updated Title", stage: "code_review" })

          expect(result.success?).to be true
          expect(result.data).to eq(task)
          expect(task.reload.title).to eq("Updated Title")
          expect(task.stage).to eq("code_review")
        }.not_to have_enqueued_mail(TaskMailer, :task_completed)
      end
    end

    context "when params are invalid" do
      it "returns a failure result and does not enqueue email" do
        expect {
          result = described_class.call(task: task, params: { title: nil })

          expect(result.failure?).to be true
          expect(result.error).not_to be_empty
          expect(result.data).to eq(task)
        }.not_to have_enqueued_mail(TaskMailer, :task_completed)
      end
    end
  end
end
