class BingoChallengesController < ApplicationController
  before_action :logged_in_user


  def index
  end

  def show
  end

  def random
    if params[:from_form]
      @level = params[:level].to_i
      @lives = params[:lives].to_i
      @tiles = params[:tiles]
      @found = params[:found].split(" ") 

      @solutions = WordEntry.where(letters: @tiles).map{ |w| w.word }

      if params[:skip]
        flash.now[:notice] = "Skipped <strong>#{@tiles.split(//).join(' ')}</strong> <br/>Missed bingos: #{(@solutions - @found).join(', ')}".html_safe
        @lives = @lives - 1
        next_random_level
      elsif params[:restart]
          flash.now[:notice] = "Missed bingos: #{(@solutions - @found).join(', ')}".html_safe
          new_random_game
      else
        next_random_level
      end
    else
      new_random_game
    end
  end




  private

    def new_random_game
      @level = 1
      @lives = 3
      @found = []
      @tiles, @solutions  = find_random_tiles_and_solutions
    end

    def next_random_level()
      @level = @level + 1
      @found = []
      @tiles, @solutions = find_random_tiles_and_solutions
    end

    def find_random_tiles_and_solutions
      tiles     = WordEntry.where(length: 7).sample.letters
      solutions = WordEntry.where(letters: tiles).map{ |w| w.word }
      return tiles, solutions
    end
end