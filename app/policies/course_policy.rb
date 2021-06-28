class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def show?
    #If it is published and approved.
    @record.published && @record.approved || 
    #If the user is an administrator
    @user.present? && @user.has_role?(:admin) ||
    #If the user CREATED the course.
    @user.present? && @record.user == @user ||
    #If said user has already purchased the course. 
    @user.present? && @record.bought(@user)

  end

  def edit?
    @record.user_id == user.id
  end

  def update?
    @record.user_id == user.id
  end

  def new?
    @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def destroy?
   @user.has_role?(:admin) || @record.user == @user
  end

  def owner?
    @record.user_id == user.id
  end

  def approve?
    @user.has_role?(:admin)
  end

end
