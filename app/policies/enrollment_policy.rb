class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end


  def index?
    #Only admins can view
    @user.has_role?(:admin)
  end


  def edit?
    #Only owners can edit
    @record.user_id == @user.id
  end

  def update?
    #Only owners can update
    @record.user_id == @user.id
  end


  def destroy?
    #Only admins can destroy
    @user.has_role?(:admin)
  end



end