# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    user_owns_repository?
  end

  def create?
    user_owns_repository?
  end
end
