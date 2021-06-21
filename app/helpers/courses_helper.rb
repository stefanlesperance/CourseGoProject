module CoursesHelper
	#This seems to define a method being called as a button in my view.
	#Long term, keep logic OUT of views. Starve Views, Skinny Controllers, Fat Models
	#Fascinating way to employ a helper and keep my code miles from view or anything else.
	def enrollment_button(course)
		if current_user
			#Buying Logic Course
			if course.user == current_user
				link_to "You created this course. View Analytics", course_path(course)
				#logic below verifies if any of the enrollments in that course have the current_user
			elsif course.enrollments.where(user: current_user).any?
				link_to "You bought this course. Keep Learning!", course_path(course)
			elsif course.price > 0 #course is not free
				#you can add buttons here, or replace them with links, its very fascinating.
				#I suspect STRIPE is up next.
				link_to number_to_currency(course.price), new_course_enrollment_path(course), class: "btn btn-md btn-success"
			else
				link_to "Free", new_course_enrollment_path(course), class: "btn btn-md btn-success"
			end
		else
			#For people not logged in, this will trigger them to be logged in, and then redirected to the course path
			link_to "Check Price", course_path(course), class: "btn btn-md btn-success"
		end
	end
end
