class Course < ApplicationRecord
	validates :title, :short_description, :language, :price, :level, presence: true
	validates :description, presence: true, length: { :minimum => 5}
	#Singular 'user' as it belongs to only one at a time
	belongs_to :user
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
end
