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
     "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Æ", "Ø", "Å", "Ü"]
   end

  def words_starting_with(x)
    filtered = @words.select { |w| w.text[0] == x}
    filtered = filtered.map { |w| w.text}.join(" ")
    "<h2>#{x}</h2>#{filtered}".html_safe
  end
end