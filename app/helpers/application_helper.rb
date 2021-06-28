module ApplicationHelper
	include Pagy::Frontend


	def crud_label(key)
		case key
			when 'create'
				"<i class = 'fa fa-plus'></i>".html_safe
			when 'update'
				"<i class = 'fa fa-pen'></i>".html_safe
			when 'destroy'
				"<i class = 'fa fa-trash'></i>".html_safe
		end
	end



	#Neat way of introducing icons via helpers.
	#Rather than manually adding all of them.
	def model_label(model)
		case model
			when 'Course'
				"<i class = 'fa fa-graduation-cap'></i>".html_safe
			when 'Lesson'
				"<i class = 'fa fa-tasks'></i>".html_safe
		end
	end
end
