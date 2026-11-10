class TaskPolicy < ApplicationPolicy
  def destroy?
    user.admin?
  end

  def edit?
    update?
  end

  def update?
    true
  end

  def toggle_reviewer?
    true
  end
end
