json.array!(@research_questions) do |research_question|
  json.extract! research_question, :id, :name, :description, :private
  json.url research_question_url(research_question, format: :json)
end
