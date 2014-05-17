#!/usr/bin/ruby

# Calcualtes the probability of drawing a given word from a full bag of tiles

def word_prob(word)
  letters = word.split(//)
  count = letters.count

  n = numerator(letters)
  count.times do |i|
    subbed_once = sub_nth_letter_with_blank(letters, i)
    (i...count).each do |j|
      subbed_once_or_twice = sub_nth_letter_with_blank(subbed_once, j)
      n += numerator(subbed_once_or_twice)
    end
  end
  n * factorial(count) / denominator(count)
end


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


def numerator(letters)
  tiles = bag()
  p = 1.0
  letters.each do |letter|
    remaining = tiles[letter]
    return 0 unless remaining and remaining > 0
    p *= remaining
    tiles[letter] -= 1
  end
  p
end

def sub_nth_letter_with_blank(letters, n)
  ls = letters.clone
  ls[n] = "?"
  ls
end

def factorial(x)
  denominator x, x
end

def denominator(count, i = 100)
  count.zero? ? 1.0 : i * denominator(count - 1, i - 1)
end

def bag()
  { "A" => 7, "H" => 3, "O" => 4, "W" => 1,
    "B" => 3, "I" => 5, "P" => 2, "Y" => 1,
    "C" => 1, "J" => 2, "R" => 6, "Æ" => 1,
    "D" => 5, "K" => 4, "S" => 6, "Ø" => 2,
    "E" => 9, "L" => 5, "T" => 6, "Å" => 2,
    "F" => 4, "M" => 3, "U" => 3, "?" => 2,
    "G" => 4, "N" => 6, "V" => 4 }
end




def test()
  print "testing prob of ABC: "
  p = (21.0  +  #abc
        14.0 +  #a??
        6.0 +   #?b?
        2.0 +   #??c
        42.0 +  #ab?
        14.0 +  #a?c
        6.0)    #?bc
  p *= factorial(3) / (100 * 99 * 98)
  print " (#{p}) "
  puts p == word_prob("ABC") ? "PASSED!" : "FAILED!"
end
test()
#puts word_prob("PPPP")