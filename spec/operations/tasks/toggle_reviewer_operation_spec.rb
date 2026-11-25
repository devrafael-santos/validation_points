require "rails_helper"

RSpec.describe Tasks::ToggleReviewerOperation do
  let(:task) { tasks(:one) }
  let(:user) { users(:one) }

  describe ".call" do
    context "when user is not the reviewer" do
      it "assigns the reviewer and enqueues notification email" do
        expect {
          result = described_class.call(task: task, user: user)

          expect(result.success?).to be true
          expect(result.data).to eq(task)
          expect(task.reload.reviewer).to eq(user)
        }.to have_enqueued_mail(TaskMailer, :reviewer_assigned).with(task)
      end
    end

    context "when user is already the reviewer" do
      before do
        task.update!(reviewer: user)
      end

      it "removes the reviewer and does not enqueue email" do
        expect {
          result = described_class.call(task: task, user: user)

          expect(result.success?).to be true
          expect(result.data).to eq(task)
          expect(task.reload.reviewer).to be_nil
        }.not_to have_enqueued_mail(TaskMailer, :reviewer_assigned)
      end
    end

    context "when update fails" do
      before do
        allow(task).to receive(:update).and_return(false)
        allow(task.errors).to receive(:full_messages).and_return([ "Erro ao atualizar" ])
      end

      it "returns a failure result" do
        result = described_class.call(task: task, user: user)

        expect(result.failure?).to be true
        expect(result.error).to eq([ "Erro ao atualizar" ])
      end
    end
  end
end
