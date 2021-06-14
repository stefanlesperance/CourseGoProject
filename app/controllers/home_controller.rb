class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @courses = Course.all.limit(3)
    #This confuses me, the created_at: : desc => Descending Order!
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
  end
end
