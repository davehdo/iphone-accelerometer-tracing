class Accel
  include Mongoid::Document
  field :accelx, type: Float
  field :accely, type: Float
  field :accelz, type: Float
  field :rota, type: Float
  field :rotb, type: Float
  field :rotg, type: Float
  field :lat, type: Float
  field :lng, type: Float
  field :accuracy, type: Float
  field :heading, type: Float
  field :speed, type: Float
  field :user_identifier, type: String
  field :timestamp, type: Time
  
  def as_json(options={})
    super(options.merge(:only => [:accelx, :accely, :accelz, :rota, :rotb, :rotg, :lat, :lng, :accuracy, :heading, :speed, :timestamp, :user_identifier])).merge({id: self.to_param})
  end

end
