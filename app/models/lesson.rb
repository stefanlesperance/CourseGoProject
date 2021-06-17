class Lesson < ApplicationRecord
  belongs_to :course
  validates :title, :content, :course, presence: true

  has_rich_text :content

  extend FriendlyId
  friendly_id :title, use: :slugged
  
    include PublicActivity::Model
    # We track the owner by assigning it based on the current user
    tracked owner: Proc.new{ |controller, model| controller.current_user}

    #This converts the title to a proper string from the ActiveRecord piece it currently is.
    def to_s
      title
    end

end
