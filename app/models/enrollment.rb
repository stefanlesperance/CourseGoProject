class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  #Ensures no enrollment can exist without the presence of a course or user.
  validates :user, :course, presence: true
  

  #Effectively forces that if one exists, the other MUST exist.
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?


  validates_uniqueness_of :user_id, scope: :course_id #user cant be subscribed to same course twice
  #User cannot be enrolled  twice, course cannot have the same ID twice. Secured on both ends
  validates_uniqueness_of :course_id, scope: :user_id #user cant be subscribed to same course twice

  validate :cant_subscribe_to_own_course # user cannot subscribe if course.user == current_user.

  scope :pending_review, -> {where(rating: [0, nil, ""], review: [0, nil, ""])}


  extend FriendlyId
  #We lack an otherwise effective string, so we use the to_s method below, which will provide a generated string
    friendly_id :to_s, use: :slugged

  def to_s
    user.to_s + " " +  course.to_s
  end


  protected

  def cant_subscribe_to_own_course
    # If a new enrollment is being created
    if self.new_record?
      #If said enrollment's user_id parameter is the same as the owner user id of the course
      if self.user_id.present?
        if user_id == course.user_id
          #Generate error
          errors.add(:base, "You cannot subscribe to your own course")
        end
      end
    end
  end


end
