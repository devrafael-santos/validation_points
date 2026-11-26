require "rails_helper"

RSpec.describe Tasks::UrgentAlertJob, type: :job do
  let(:task) { tasks(:one) }

  describe ".perform_later" do
    it "enqueues the job on the critical queue" do
      expect {
        described_class.perform_later(task.id)
      }.to have_enqueued_job(described_class).with(task.id).on_queue("critical")
    end
  end

  describe "#perform" do
    before do
      allow(Rails.logger).to receive(:warn)
    end

    context "when task is urgent" do
      before { task.update!(priority: :urgent) }

      it "logs an urgent alert warning" do
        described_class.perform_now(task.id)

        expect(Rails.logger).to have_received(:warn).with("[URGENT ALERT] Task [#{task.jira_key}] '#{task.title}' requires immediate attention!")
      end
    end

    context "when task is not urgent" do
      before { task.update!(priority: :low) }

      it "does not log an alert" do
        described_class.perform_now(task.id)

        expect(Rails.logger).not_to have_received(:warn)
      end
    end

    context "when task does not exist" do
      it "does not raise error and does not log an alert" do
        expect {
          described_class.perform_now(-1)
        }.not_to raise_error

        expect(Rails.logger).not_to have_received(:warn)
      end
    end
  end
end
