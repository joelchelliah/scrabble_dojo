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

      guess = params[:guess]
      guess = guess.upcase.tr("å-ü", "Å-Ü") unless guess.blank?

      solutions      = WordEntry.where(letters: @tiles.split(//).sort.join).map{ |w| w.word }
      @num_solutions = solutions.count

      guess_is_correct = solutions.include?(guess)
      guess_is_unique  = !@found.include?(guess)

      if params[:shuffle]
        @tiles = @tiles.split(//).shuffle.join
      elsif params[:skip]
        flash.now[:notice] = "Skipped #{@tiles}. Missed bingos: #{(solutions - @found).join(', ')}"
        @lives = @lives - 1
        next_random_level
      elsif params[:restart]
          flash.now[:success] = "Awesome! You made it to level #{@level}"
          new_random_game
      elsif guess_is_correct and guess_is_unique and @num_solutions == @found.count + 1
        flash.now[:success] = "#{guess} is correct. Next level!"
        next_random_level
      else
        if !guess_is_correct
          flash.now[:error] = "#{guess} is incorrect" unless guess.blank?
        elsif !guess_is_unique
          flash.now[:notice] = "#{guess} has already been found"
        else
          flash.now[:success] = "#{guess} is correct"
          @found << guess
        end
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
      @tiles, @num_solutions  = find_random_tiles_and_num_solutions
    end

    def next_random_level()
      @level = @level + 1
      @found = []
      @tiles, @num_solutions = find_random_tiles_and_num_solutions
    end

    def find_random_tiles_and_num_solutions
      tiles         = WordEntry.where(length: 7).sample.letters
      num_solutions = WordEntry.where(letters: tiles).count
      return tiles, num_solutions
    end
end