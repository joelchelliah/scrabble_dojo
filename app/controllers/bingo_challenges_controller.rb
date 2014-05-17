class BingoChallengesController < ApplicationController
  before_action :logged_in_user
  before_action :set_bingo_challenge, only: [:show, :play]

  def index
    @random     = BingoChallenge.find_by(mode: "random")
    @challenges = BingoChallenge.all
  end

  def show
    new_challenge
    c  = @challenge
    @tiles     = c.tiles_list.split(" ")[c.level - 1]
    @solutions = WordEntry.where(letters: @tiles).map{ |w| w.word }
  end

  def play
    form_request = params[:from_form]

    if form_request == "yield"
      new_challenge
    elsif form_request == "next"
      next_level
    elsif form_request == "win"
      reset_challenge
      redirect_to challenges_path
    end

    redirect_to @challenge
  end

  

  private

    def set_bingo_challenge
        @challenge = BingoChallenge.find(params[:id])
    end

    def new_challenge
      @challenge.level = 1
      if @challenge.ordered?
        @challenge.tiles_list = "to be implemented"
      else
        # including :word in the select clause to make it work in PG
        @challenge.tiles_list = WordEntry.select(:letters, :word).where(length: 7).uniq.sample(@challenge.size).map { |w| w.letters }.join(" ")
      end

      unless @challenge.save
        flash[:error] = "Could not initiate challenge."
        redirect_to challenges_path 
      end
    end

    def next_level
      @challenge.level += 1

      unless @challenge.save
        flash[:error] = "Could not proceed to next level."
        redirect_to challenges_path 
      end
    end

    def reset_challenge
      if @challenge.reset!
        flash[:success] = "Challenge: #{@name} completed!"
      else
        flash[:error] = "Could not reset challenge."
      end
    end
end