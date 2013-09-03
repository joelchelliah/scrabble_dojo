class Word < ActiveRecord::Base
  validates :text, length: { maximum: 15 }
end
