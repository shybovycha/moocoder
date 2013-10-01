json.array!(@problems) do |problem|
  json.extract! problem, :title, :body, :time_limit, :memory_limit
  json.url problem_url(problem, format: :json)
end
