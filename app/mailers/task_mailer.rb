class TaskMailer < ApplicationMailer
  def reviewer_assigned(task)
    @task = task
    @reviewer = task.reviewer

    mail(to: User.pluck(:email), subject: "[#{@task.jira_key}] Análise iniciada por #{@reviewer.name}")
  end

  def task_completed(task)
    @task = task

    mail(to: User.pluck(:email), subject: "[#{@task.jira_key}] Tarefa '#{@task.title}' entregue em Produção! 🎉")
  end
end
