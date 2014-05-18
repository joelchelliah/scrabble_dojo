class BingoChallenge < ActiveRecord::Base

  scope :random,     -> { where(mode: "random").first }
  scope :ordered,    -> { where(mode: "ordered").order("order_id ASC") }
  scope :last_order, -> { ordered.maximum(:order_id) }

  validates :mode, presence: true
  validates :order_id, :numericality => { greater_than_or_equal_to: 0 }, presence: true


  def name 
    name = "#{mode.capitalize} (#{self.size})" if self.random?
    name = "(#{self.min + 1} - #{self.max + 1})" if self.ordered?
    name
  end

  def min
    self.size * (self.order_id - 1)
  end

  def max
    self.size * self.order_id - 1
  end

  def random?
    self.mode == "random"
  end

  def ordered?
    self.mode == "ordered"
  end

  def size
    50
  end

  def reset?
    self.tiles_list.blank? or self.level.zero?
  end

  def reset!
    self.tiles_list = ""
    self.level = 0
    self.save
  end
end
