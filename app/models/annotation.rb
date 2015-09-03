class Annotation
  include Mongoid::Document
  
  embedded_in :patient
  
  field :occurred_at, type: Time
  field :category, type: String
  field :comment, type: String
end
