class HomeController < ApplicationController
  def index
    bingos = Word.where(length: 7)
    @word = bingos.first(:offset => rand(bingos.length))
    @word = @word.text if @word
  end
end
