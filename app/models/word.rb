class Word < ActiveRecord::Base
  validates :text, length: { maximum: 15 }

  def to_s()
  	text
  end
end
