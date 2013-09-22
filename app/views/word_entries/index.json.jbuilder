json.array!(@words) do |word|
  json.extract! word, :text, :letters, :length, :first_letter
  json.url word_url(word, format: :json)
end
