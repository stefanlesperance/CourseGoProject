class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @courses = Course.all.limit(3)
    #This confuses me, the created_at: : desc => Descending Order!
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
    #@continue_courses = Course.limit(3).order(created_at: :desc).joins(:enrollments).where(enrollments: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)
    #I need to better understand the use of these ':' - Far too often I forgot them at random, but place them without understanding
    @latest_reviews = Enrollment.reviewed.order(rating: :desc, created_at: :desc).limit(3)

    @top_rated_courses = Course.order(average_rating: :desc, created_at: :desc).limit(3)
    @popular_courses = Course.order(enrollments_count: :desc, created_at: :desc).limit(3)
    #The lack of the ransack (see continue courses) makes sense - I'm not PASSING anything, and there are no params. Simply put
    #I only need to join the tables, use current_user, and you've located all courses in question.
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)
  end

  def activity
    @activity = PublicActivity::Activity.all
  end
end
