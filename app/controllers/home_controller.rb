class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    #Does this need to be scoped? Probably.
    @courses = Course.all_courses
    #This confuses me, the created_at: : desc => Descending Order!
    @latest_courses = Course.latest_courses
    #@continue_courses = Course.limit(3).order(created_at: :desc).joins(:enrollments).where(enrollments: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)
    #I need to better understand the use of these ':' - Far too often I forgot them at random, but place them without understanding
    @latest_reviews = Enrollment.latest_reviews

    @top_rated_courses = Course.top_rated_courses
    @popular_courses = Course.popular_courses
    #The lack of the ransack (see continue courses) makes sense - I'm not PASSING anything, and there are no params. Simply put
    #I only need to join the tables, use current_user, and you've located all courses in question.
    @purchased_courses = Course.purchased_courses(current_user)
  end

  def activity
    @activity = PublicActivity::Activity.all
  end
end
