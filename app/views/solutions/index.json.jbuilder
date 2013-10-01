json.array!(@solutions) do |solution|
  json.extract! solution, :body, :status
  json.url solution_url(solution, format: :json)
end
