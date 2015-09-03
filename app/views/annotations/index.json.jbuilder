json.array!(@annotations) do |annotation|
  json.extract! annotation, :occurred_at
  json.id annotation.to_param
  json.url patient_url(annotation, format: :json)
end
