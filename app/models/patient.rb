class Patient
  include Mongoid::Document
  field :name, type: String
  field :uid, type: String
  field :active, type: Mongoid::Boolean
end
