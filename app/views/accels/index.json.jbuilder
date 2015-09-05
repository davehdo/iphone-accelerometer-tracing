json.array!(@accels) do |accel|
  json.extract! accel, :accelx, :accely, :accelz, :rota, :rotb, :rotg, :user_identifier, :timestamp
  json.id accel.to_param
  json.url accel_url(accel, format: :json)
end
