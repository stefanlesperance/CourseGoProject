class Course < ApplicationRecord
	validates :title, :short_description, :language, :price, :level, presence: true
	validates :description, presence: true, length: { :minimum => 5}
	#Singular 'user' as it belongs to only one at a time
	belongs_to :user, counter_cache: true
	#dependent: :destroy -> Course with lessons, if destroyed, will automatically destroy those linked lessons
	has_many :lessons, dependent: :destroy
	has_many :enrollments, dependent: :restrict_with_error
		# I removed my dependent: :destroy because users shouldn't lose their courses if enrolled.
		#It's the sort of real world buisness thinking that must be applied. 
	has_many :user_lessons, through: :lessons

	validates :title, uniqueness: true

	#scopes for home_controller
	scope :purchased_courses, -> (user){ joins(:enrollments).where(enrollments: {user: user}).order(created_at: :desc).limit(3)}
	scope :popular_courses, -> {order(enrollments_count: :desc, created_at: :desc).limit(3)}
	scope :top_rated_courses, -> {order(average_rating: :desc, created_at: :desc).limit(3)}
	scope :latest_courses, -> {all.limit(3).order(created_at: :desc)}
	scope :all_courses, -> {all.limit(3)}
	scope :published, -> {where(published: true)}
	scope :unpublished, -> {where(published: false)}
	scope :approved, -> {where(approved: true)}
	scope :unapproved, -> {where(approved: false)}


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

	  def progress(user)
	  	#(user_lessons.where(user: user).count /self.lessons.count).to_f*100
		 unless self.lessons_count == 0
	      user_lessons.where(user: user).count/self.lessons_count.to_f*100
	    end
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
