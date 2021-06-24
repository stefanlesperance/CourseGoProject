class UserLesson < ApplicationRecord
	belongs_to :user
	belongs_to :lesson

	validates :user, :lesson, presence: true

	#Ensures the uniqueness of each record added to the DB.
	#Duplicates become impossible, like a unique key_code of sorts.
	validates_uniqueness_of :user_id, scope: :lesson_id #User cant see same lesson twice for the first time
	validates_uniqueness_of :lesson_id, scope: :user_id 
end