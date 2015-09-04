class AnnotationsController < ApplicationController
  before_action :set_patient
  
  def index
    @annotations = @patient.annotations
  end

  # def new
  # end

  def show
    @annotation = @patient.annotations.find( params[:id] )
  end

  # def edit
  # end

  def update
  end

  def create
    @annotation = @patient.annotations.build( annotation_params )
    respond_to do |format|
      if @annotation.save
        format.html { redirect_to url_for([@patient, @annotation]), notice: 'Annotation was successfully created.' }
        format.json { render :show, status: :created, location: url_for([@patient, @annotation]) }
      else
        format.html { render :new }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
    
  end

  def destroy
  end
  
  private
  
  def set_patient
    @patient = Patient.find( params[:patient_id] )
    
  end
  
  def annotation_params
    params.require(:annotation).permit(:patient_id, :comment, :category, :occurred_at)
  end
  
end
