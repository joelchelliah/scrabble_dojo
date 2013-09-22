class DojoController < ApplicationController
  def home
  	letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
       			 	 "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Æ", "Ø", "Å"]
    
    random_bingo_entry = WordEntry.bingos_from_letter(letters.sample).sample
    @random_bingo = ""
    @random_bingo = random_bingo_entry.word unless random_bingo_entry.blank?
  end
end
