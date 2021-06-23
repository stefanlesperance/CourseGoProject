class Course < ApplicationRecord
	validates :title, :short_description, :language, :price, :level, presence: true
	validates :description, presence: true, length: { :minimum => 5}
	#Singular 'user' as it belongs to only one at a time
	belongs_to :user, counter_cache: true
	#dependent: :destroy -> Course with lessons, if destroyed, will automatically destroy those linked lessons
	has_many :lessons, dependent: :destroy
	has_many :enrollments, dependent: :destroy

	validates :title, uniqueness: true

	def to_s
		title
	end
	has_rich_text :description

	extend FriendlyId
  	friendly_id :title, use: :slugged

  	  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
	  def self.languages
	    LANGUAGES.map { |language| [language, language] }
	  end

	  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
	  def self.levels
	    LEVELS.map { |level| [level, level] }
	  end
  include PublicActivity::Model
	  # We track the owner by assigning it based on the current user
	  tracked owner: Proc.new{ |controller, model| controller.current_user}

	  def bought(user)
	  	#Not sure why user.id is inside []
	  	self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
	  end


	def update_rating
		#Update the rating if it has any enrollments
		if enrollments.any? && enrollments.where.not(rating: nil).any?
			update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
		else
			update_column :average_rating, (0)
		end
	end


end
