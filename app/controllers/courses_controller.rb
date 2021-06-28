class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_course, only: %i[ show edit update destroy approve unapprove ]

  # GET /courses or /courses.json
  def index
    #I should check for emptiness first, that would be helpful, drag that code over.
    # if params[:title]
    #   @courses = Course.where('title ILIKE ?', "%#{params[:title]}%") #case insensitive
    # else
      #@q = Course.ransack(params[:q])
      # Distinct true must be removed from the new version, because of course, the user will not be 'unique'
        #he will appear multiple times.
      #@courses = @q.result.includes(distinct: true)
      #@courses = @q.result.includes(:user)
      @ransack_path = courses_path 
      @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
      #@courses = @ransack_courses.result.includes(:user)
      @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
  end

  # GET /courses/1 or /courses/1.json


  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)
    #Enrollments is needed, because course doesn't record whosee nrolled in it. Hence, the joins/merge
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    #Enrollments is needed, because course doesn't record whosee nrolled in it. Hence, the joins/merge
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end


  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user ).ransack(params[:courses_search], search_key: :courses_search)
    #Here I only need the course to tell me what the user id of the creator is
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.where(user: current_user ).ransack(params[:courses_search], search_key: :courses_search)
    #Here I only need the course to tell me what the user id of the creator is
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end


  #Admin controlled button that allows course to be viewed in the all course section.
  def approve
    #The below method is me authorizing a SPECIFC policy for a method. It can be reused if method != policy name
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course approved!"
  end


  def unapprove
    #The below method is me authorizing a SPECIFC policy for a method. It can be reused if method != policy name
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, alert: "Course unapproved and hidden!"
  end
  
  def show
    authorize @course
    @lessons = @course.lessons
    @enrollments_with_review = @course.enrollments.reviewed
  end 

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
      authorize @course
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to @course, alert: "Course still has enrollments." 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      # This is the old
      #@course = Course.find(params[:id])
      # This is new. Now we are looking for a DB entry via a slug field.
      @course = Course.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :short_description, :published, :language, :level, :price)
    end
end
