class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  #Don't forget the question mark!
  def show?
    @user.has_role?(:admin) || @record.course.user_id == @user.id
  end


  def edit?
    #@record.course.user_id == user.id - means only owner/creator, as given by the id, can edit
    @record.course.user_id == @user.id
  end

  def update?
    @record.course.user_id == @user.id
  end

  def new?
    #@user.has_role?(:teacher)
  end

  def create?
    #@user.has_role?(:teacher)
    #Comparing the user id of the course's ActiveRecord versus THAT of the individual attempting to create
    @record.course.user_id == @user.id
  end

  def destroy?
    @record.course.user_id == @user.id
  end

end
