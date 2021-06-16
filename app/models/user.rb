class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #Course is pluralized 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

    rolify

  has_many :courses
  def to_s
    email
end

  def username
    self.email.split(/@/).first
  end

  after_create :assign_default_role

   def assign_default_role
    #If there is only one user, or the first user has just been created, then all roles are assigned.
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      #More than one user, restricts admin, they can be both teacher and student, though it varies.
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher) #if you want any user to be able to create own courses
    end
  end


  validate :must_have_a_role, on: :update

    private
    def must_have_a_role
      unless roles.any?
        errors.add(:roles, "must have at least one role")
      end
    end
end
