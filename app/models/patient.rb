class Patient
  include Mongoid::Document
  
  embeds_many :annotations
  
  field :name, type: String
  field :uid, type: String
  field :active, type: Mongoid::Boolean
end
