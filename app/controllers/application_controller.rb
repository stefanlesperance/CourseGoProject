class ApplicationController < ActionController::Base
	before_action :authenticate_user!

	after_action :user_activity

	include Pundit
  	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	include PublicActivity::StoreController #save current_user using gem public activity

	before_action :set_global_variables, if :user_signed_in?
	#From my understanding, if the user is signed in, search will work.
	#it will create a GLOBAL variable, accessible everywhere, which, presumably, will be used to search
		def set_global_variables
			@ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) # for navbar search
		end
	end

	private

	def user_activity
		#try - a method that usually receives another method, denoted by a symbol
		#symbol :SYMBOL
		#try is meant to avoid a nil issue, where nil is returned, potentially breaking the program
		current_user.try :touch
		#touch meanwhile is used to update the updated_at field for persisted objects
		# Ultimately the above method exists to try and update the updated_at field without breaking the program by returning nil
	end

  def user_not_authorized #pundit method see above
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end


end
