json.array!(@compilers) do |compiler|
  json.extract! compiler, :name, :command
  json.url compiler_url(compiler, format: :json)
end
