class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    instructors = Instructor.all
    render json: instructors
  end

  def show
    instructor = Instructor.find(params[:id])
    if instructor
      render json: instructor
    else
      render_not_found_response
    end
  end

  def create
    new_instructor = Instructor.create(instructor_params)
    instructors = Instructor.all
    if !instructors.include?(new_instructor)
      render json: new_instructor, status: :created
    else
      new_instructor.destroy
      render json: { error: "Instructor already created" }, status: :unprocessable_entity
    end
  end

  def destroy
    instructor = Instructor.find(params[:id])
    instructor.destroy
  end

  def update
    instructor = Instructor.find(params[:id])
    if instructor
      instructor.update(instructor_params)
      render json: instructor
    else
      render_not_found_response
    end
  end

  private

  def instructor_params
    params.permit(:name)
  end

  def render_not_found_response
    render json: { error: "Instructor not found" }, status: :not_found
  end

end
