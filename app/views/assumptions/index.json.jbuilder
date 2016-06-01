json.array!(@assumptions) do |assumption|
  json.extract! assumption, :id, :name, :description, :critical, :type, :required_dataset_fields, :fail_on_missing, :r_code, :question, :argument_inverted
  json.url assumption_url(assumption, format: :json)
end
