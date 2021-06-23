class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #Course is pluralized 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

    rolify

  has_many :courses, counter_cache: true
  has_many :enrollments, counter_cache: true

  extend FriendlyId
    friendly_id :email, use: :slugged

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

  def online?
    #Basically if the updated at was changed less than two minutes ago, they are deemed 'online'
    updated_at > 2.minutes.ago
  end

    def buy_course(course)
      #This is designed to buy the course, to trigger the enrollment by summoning Enrollments method.
      self.enrollments.create(course: course, price: course.price)
    end


    private
    def must_have_a_role
      unless roles.any?
        errors.add(:roles, "must have at least one role")
      end
    end




end
