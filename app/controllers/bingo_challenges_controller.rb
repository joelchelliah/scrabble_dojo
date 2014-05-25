class BingoChallengesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :destroy]

  def index
    @random  = find_or_create_random_challenge
    @ordered = current_user.bingo_challenges.ordered
  end

  def show
    form_request = params[:from_form]

    if params[:from_form]
      end_challenge     if form_request == "next" and @challenge.level == @challenge.size
      next_level        if form_request == "next"
      restart_challenge if form_request == "yield"
    else
      restart_challenge
    end

    prepare_level
  end

  def new
    @challenge = current_user.bingo_challenges.build
  end

  def create
    @challenge = current_user.bingo_challenges.build(challenge_params)
    if @challenge.save
      flash[:success] = "Created ordered challenge: #{@challenge.name}."
      redirect_to bingo_challenges_path
    else
      render 'new'
    end
  end

  def destroy
    @challenge.destroy
    redirect_to bingo_challenges_path
  end

  
  private

    def find_or_create_random_challenge
      if current_user.bingo_challenges.random.first.nil?
        unless current_user.bingo_challenges.build(mode: "random", min_range: 1, max_range: 50).save
          flash[:error] = "Could not create default challenge."
          redirect_to root_url
        end
      end
      current_user.bingo_challenges.random.first
    end

    def restart_challenge
      @challenge.level = 1
      if @challenge.ordered?
        @challenge.tiles_list = WordEntry.tiles_for_ordered_bingo_challenge(@challenge.min_range, @challenge.max_range).join(" ")
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
      flash[:error] = "Could not proceed to next level." unless @challenge.save
    end

    def end_challenge
      flash[:success] = "Challenge: #{@challenge.name} completed!"
      redirect_to bingo_challenges_path
    end

    def prepare_level
      @tiles     = @challenge.tiles_list.split(" ")[@challenge.level - 1]
      @solutions = WordEntry.where(letters: @tiles).map{ |w| w.word }
    end


    def correct_user
      @challenge = current_user.bingo_challenges.find(params[:id])
      if @challenge.nil?
        flash[:error] = "Could not find challenge"
        redirect_to root_url
      end
    end

    def challenge_params
      params.require(:bingo_challenge).permit(:mode, :min_range, :max_range)
    end
end