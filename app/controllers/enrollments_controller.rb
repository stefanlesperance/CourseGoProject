class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]
  before_action :set_course, only: [:new, :create]
  # GET /enrollments or /enrollments.json
  def index
    #@enrollments = Enrollment.all
    #These custom paths for ransack are passed, depending on what ACTION is calling the view.
    #In Index, itll grab the general, but for my_students, it recognizes the path for that view must be that specific one.
    #It's genius
    @ransack_path = enrollments_path
    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user), items: 5)
    

    authorize @enrollments
  end

  # GET /enrollments/1 or /enrollments/1.json
  def my_students
    @ransack_path = my_students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: {user: current_user}).ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user), items: 5)
    render 'index'
  end


  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    if @course.price > 0
      flash[:alert] = "You cannot access paid courses yet"
      redirect_to new_course_enrollment_path(@course)
    else
      #if price is more than zero
      #current_user functions as passing a user, which is why I can summon this method
      @enrollment = current_user.buy_course(@course)
      redirect_to course_path(@course), notice: "You are enrolled"
    end

    #Old method of Enrollment
    # @enrollment = Enrollment.new(enrollment_params)
    # @enrollment.price = @enrollment.course.price

    # respond_to do |format|
    #   if @enrollment.save
    #     format.html { redirect_to @enrollment, notice: "Enrollment was successfully created." }
    #     format.json { render :show, status: :created, location: @enrollment }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @enrollment.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:rating, :review)
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end
end
