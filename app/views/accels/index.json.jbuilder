json.array!(@accels) do |accel|
  json.extract! accel, :accelx, :accely, :accelz, :rota, :rotb, :rotg, :lat, :lng, :accuracy, :heading, :speed, :user_identifier, :timestamp
  json.id accel.to_param
end
