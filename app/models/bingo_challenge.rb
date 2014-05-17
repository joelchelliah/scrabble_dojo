class BingoChallenge < ActiveRecord::Base

  validates :mode, presence: true
  validates :order, :numericality => { greater_than_or_equal_to: 0 }, presence: true


  def name
    s = self.size
    o = self.order

    name = mode.capitalize
    name << " (#{s})" if self.random?
    name << " (#{s * (o - 1) + 1} - #{s * o})" if self.ordered?
    name
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
