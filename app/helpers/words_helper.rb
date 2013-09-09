module WordsHelper

  def header_text(length, first_letter)
    unless length
      "Alle ordene"
    else
      "Ord med #{length} bokstaver"
    end
  end

  def alfabet()
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
     "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Æ", "Ø", "Å"]
   end

  def words_starting_with(x)
    filtered = @words.inject("") do |result, w|
      if w.text[0] == x then "#{result} #{w.text}" else result end
    end
    "<h3>#{x}</h3>#{filtered}<hr/>".html_safe
  end
end