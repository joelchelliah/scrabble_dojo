class BingoChallengesController < ApplicationController
  before_action :logged_in_user
  before_action :set_bingo_challenge, only: [:show, :play]

  def index
    @random  = BingoChallenge.random
    @ordered = BingoChallenge.ordered
  end

  def show
    new_challenge
    prepare_level
  end

  def play
    form_request = params[:from_form]

    if form_request == "yield"
      new_challenge
    elsif form_request == "next"
      next_level
    elsif form_request == "win"
      reset_challenge
      redirect_to bingo_challenges_path
    end
    prepare_level
    render 'show'
  end

  def new
    last = BingoChallenge.last_order || 0
    challenge = BingoChallenge.new(mode: "ordered", order: (last + 1), tiles_list: "", level: 0)
    if challenge.save
      flash[:success] = "Ordered challenge #{challenge.name} created!"
    else
      flash[:error] = "Could not create challenge."
    end
    redirect_to bingo_challenges_path
  end

  

  private

    def set_bingo_challenge
        @challenge = BingoChallenge.find(params[:id])
    end

    def new_challenge
      @challenge.level = 1
      if @challenge.ordered?
        @challenge.tiles_list = WordEntry.tiles_for_ordered_bingo_challenge(@challenge.min, @challenge.max).join(" ")
      else
        @challenge.tiles_list = WordEntry.tiles_for_random_bingo_challenge(@challenge.size).join(" ")
      end

      unless @challenge.save
        flash[:error] = "Could not initiate challenge."
        redirect_to bingo_challenges_path 
      end
    end

    def next_level
      @challenge.level += 1

      unless @challenge.save
        flash[:error] = "Could not proceed to next level."
        redirect_to bingo_challenges_path 
      end
    end

    def reset_challenge
      if @challenge.reset!
        flash[:success] = "Challenge: #{@name} completed!"
      else
        flash[:error] = "Could not reset challenge."
      end
    end

    def prepare_level
      @tiles     = @challenge.tiles_list.split(" ")[@challenge.level - 1]
      @solutions = WordEntry.where(letters: @tiles).map{ |w| w.word }
    end
end