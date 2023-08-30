class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  
  def index
    students = Student.all 
    render json: students
  end

  def show
    student = Student.find(params[:id])
    if student
      render json: student
    else
      render_not_found_response
    end
  end

  def create
    new_student = Student.create!(student_params)
    students = Student.all
    if !students.include?(new_student)
      render json: new_student, status: :created
    else
      new_student.destroy
      render json: { error: "Student already created" }, status: :unprocessable_entity
    end
  
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy
  end

  private

  def student_params
    params.permit(:name, :major, :age, :instructor_id)
  end

  def render_not_found_response
    render json: { error: 'Student not found' }, status: :not_found
  end

  def render_unprocessable_entity_response
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

end
