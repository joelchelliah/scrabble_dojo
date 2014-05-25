class BingoChallenge < ActiveRecord::Base

  belongs_to :user

  scope :random,     -> { find_by(mode: "random") }
  scope :ordered,    -> { where(mode: "ordered").order("min_range ASC").order("max_range ASC") }

  validates :mode, presence: true
  validates :min_range, :numericality => { greater_than_or_equal_to: 1 }, presence: true
  validates :max_range, :numericality => { greater_than: :min_range }, presence: true


  def name 
    name = "(#{self.size})" if self.random?
    name = "#{self.min_range} - #{self.max_range}" if self.ordered?
    name
  end

  def random?
    self.mode == "random"
  end

  def ordered?
    self.mode == "ordered"
  end

  def size
    self.max_range - self.min_range + 1
  end

end
