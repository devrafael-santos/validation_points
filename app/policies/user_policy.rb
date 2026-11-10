class UserPolicy < ApplicationPolicy
  create? do
    user.admin?
  end

  index? do
    user.admin?
  end

  show? do
    user.admin? || record == user
  end

  update? do
    user.admin? || record == user
  end

  delete? do
    user.admin? || record == user
  end
end
