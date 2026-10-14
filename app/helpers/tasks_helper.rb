module TasksHelper
  def project_type_badge_class(project_type)
    case project_type.to_s
    when "backend"
      "badge-backend"
    when "frontend"
      "badge-frontend"
    when "mobile"
      "badge-mobile"
    when "fullstack"
      "badge-fullstack"
    else
      "badge-default"
    end
  end

  def priority_badge_class(priority)
    case priority.to_s
    when "urgent"
      "badge-urgent"
    when "high"
      "badge-high"
    when "medium"
      "badge-medium"
    when "low"
      "badge-low"
    else
      "badge-default"
    end
  end
end
