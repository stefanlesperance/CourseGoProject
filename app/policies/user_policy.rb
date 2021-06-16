class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end


  def edit?
    @user.has_role?:admin
  end

  def update?
    @user.has_role?:admin
  end
  

end
