module WordEntriesHelper

  def header_text()
    num = %w(- - Two Three Four Five)
    
    return "#{num[@length.to_i]} letter words" if @length
    return "Short #{@letter} words" if @letter
  end

  def for_each_letter_with_words()
    alphabet().each do |letter|
      yield letter if found_words_for? letter
    end
  end
  
  def show_words_starting_with(x)
    filtered = @word_entries.inject("") do |result, w|
      if w.word[0] == x then "#{result} #{w.word}<br class='visible-phone'/>" else result end
    end
    "<h3>#{x}</h3>#{filtered}".html_safe
  end


  def search_result_text()
    anagrams_text = pluralize(@word_entries.length, "anagram")
    "Found #{anagrams_text} for <strong>#{@word}</strong>".html_safe
  end

  def stems_result_text()
    option_text = "#{@option.to_s.downcase}ed by"
    option_text = "containing" if @option == "contains"
    option_text = "affixed by" if @option == "both"
    length_text = @max_length == "15" ? "" : ", with a maximum length of <strong>#{@max_length}</strong>"
    words_text  = pluralize(@word_entries.length, "word")

    "Found #{words_text} #{option_text} <strong>#{@word}</strong>#{length_text}".html_safe
  end


  private

    def alphabet()
      ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
       "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Æ", "Ø", "Å"]
    end

    def found_words_for?(x)
      @word_entries.any? { |w| w.word[0] == x }
    end
end