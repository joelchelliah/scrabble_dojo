#!/usr/bin/ruby

# Generates record creation lines for initializing the database.
# All words are taken from the NSF-ordliste.
# Duplicate words and words of length greater than 15 are left out.

File.open('NSF-ordlisten.txt', 'r') do |input|
  File.open('db-seeds.txt', 'w') do |output|
    last_word = ""
    while line = input.gets
      word = line.split[0]
      unless word.length > 15 or last_word == word
        letters = word.split(//)
        output << "Word.create(text: '#{word}', letters: '#{letters.sort.join}', length: #{word.length}, first_letter: '#{letters.first}')\n"
        last_word = word
      end
    end
  end
end