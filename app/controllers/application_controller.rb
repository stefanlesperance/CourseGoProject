class ApplicationController < ActionController::Base
	before_action :authenticate_user!

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

	  def user_not_authorized #pundit method see above
	    flash[:alert] = "You are not authorized to perform this action."
	    redirect_to(request.referrer || root_path)
	  end


end
