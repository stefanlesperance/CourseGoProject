class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def show?
    @user.present? && @user.has_role?(:admin) ||
    @user.present? && @record.user_id == @user.id ||
    @user.present? && @record.bought(@user)
  end


  def edit?
    @user.has_role?(:admin) || @record.user_id == user.id
  end

  def update?
    @user.has_role?(:admin) || @record.user_id == user.id
  end

  def new?
    @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def destroy?
   @user.has_role?(:admin) || @record.user_id == user.id
  end

end
