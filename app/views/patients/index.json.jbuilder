json.array!(@patients) do |patient|
  json.extract! patient, :id, :name, :uid, :active
  json.url patient_url(patient, format: :json)
end
