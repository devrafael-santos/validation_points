require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "reviewer_assigned" do
    it "renders headers and body correctly" do
      task = tasks(:one)
      user = users(:one)
      task.reviewer = user
      mail = TaskMailer.reviewer_assigned(task)

      expect(mail.subject).to eq("[#{task.jira_key}] Análise iniciada por #{user.name}")
      expect(mail.to).to match_array(User.pluck(:email))
      expect(mail.from).to eq([ "from@example.com" ])
      expect(mail.body.encoded).to include(task.title)
      expect(mail.body.encoded).to include(task.jira_key)
    end
  end

  describe "task_completed" do
    it "renders headers and body correctly" do
      task = tasks(:one)
      mail = TaskMailer.task_completed(task)

      expect(mail.subject).to eq("[#{task.jira_key}] Tarefa '#{task.title}' entregue em Produção! 🎉")
      expect(mail.to).to match_array(User.pluck(:email))
      expect(mail.from).to eq([ "from@example.com" ])
      expect(mail.body.encoded).to include(task.title)
      expect(mail.body.encoded).to include(task.jira_key)
    end
  end
end
