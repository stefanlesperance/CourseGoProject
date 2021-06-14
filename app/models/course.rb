class Course < ApplicationRecord
	validates :title, presence: true
	validates :description, presence: true, length: { :minimum => 5}
	#Singular 'user' as it belongs to only one at a time
	belongs_to :user
	def to_s
		title
	end
	has_rich_text :description

end
