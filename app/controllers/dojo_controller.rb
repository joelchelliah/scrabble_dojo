class DojoController < ApplicationController
  def home
    bingos = Word.where(length: 7)
    @word = bingos.first(:offset => rand(bingos.length))
  end
end
