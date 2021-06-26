class UserLesson < ApplicationRecord
	belongs_to :user
	belongs_to :lesson
	#According to the active record guide, it effectively is a has_many  Association
	#Though the word :through is nowhere apparent.
	# In effect, Users and Lessons can be matched through this third model to 0 or more instances - I might be a little off on this
	validates :user, :lesson, presence: true

	#Ensures the uniqueness of each record added to the DB.
	#Duplicates become impossible, like a unique key_code of sorts.
	validates_uniqueness_of :user_id, scope: :lesson_id #User cant see same lesson twice for the first time
	validates_uniqueness_of :lesson_id, scope: :user_id 


end