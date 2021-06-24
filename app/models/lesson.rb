class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true

  has_many :user_lessons

  has_rich_text :content

  extend FriendlyId
  friendly_id :title, use: :slugged
  
    include PublicActivity::Model
    # We track the owner by assigning it based on the current user
    tracked owner: Proc.new{ |controller, model| controller.current_user}

    #This converts the title to a proper string from the ActiveRecord piece it currently is.
    #This is a new note.
    def to_s
      title
    end

    def viewed(user)
      self.user_lessons.where(user: user).present?
      #Alternative below
      # self.user_lessons.where(user_id: [user_id], lesson_id: [self.id]).empty?
    end

end
