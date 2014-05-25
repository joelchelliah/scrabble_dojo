class WordEntry < ActiveRecord::Base
	#default_scope 						 -> 			{ order('word ASC') }
	scope :word_length,				 -> (num) { where("length = ?", num).order('word ASC') }
	scope :short_words, 			 -> 			{ where("length < 6").order('word ASC') }
	scope :bingos, 						 -> 			{ where("length > 6 and length < 10") }
	scope :bingos_from_letter, -> (let) { bingos.where(first_letter: let) }

  scope :tiles_for_random_bingo_challenge, -> (num) do
    select(:letters).where(length: 7).distinct.sample(num).map { |w| w.letters }
  end

  scope :tiles_for_ordered_bingo_challenge, -> (min, max) do
    select(:letters, :probability).where(length: 7)
                                  .distinct
                                  .order('probability DESC')[(min-1)...max]
                                  .map { |w| w.letters }
  end


  validates :word, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 15 }
  validates :letters, presence: true
  validates :length, presence: true
  validates :first_letter, presence: true
end
