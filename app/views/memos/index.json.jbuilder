json.array!(@memos) do |memo|
  json.extract! memo, :name, :hints, :word_list
  json.url memo_url(memo, format: :json)
end