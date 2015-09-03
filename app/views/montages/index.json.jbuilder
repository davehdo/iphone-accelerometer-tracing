json.array!(@montages) do |montage|
  json.extract! montage, :id, :string
  json.url montage_url(montage, format: :json)
end
