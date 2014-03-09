class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy, :practice, :results_of]

  include MemosHelper

  def index
    @memos = sort_list_correctly_by_field(current_user.memos, :name)
  end

  def by_health
    @memos = ordered_by_health()
    render 'index'
  end

  def by_word_count
    @memos = current_user.memos.sort_by { |m| -m.word_list.size }
    render 'index'
  end

  def revise_weakest
    redirect_to ordered_by_health().first
  end

  def new
    @memo = current_user.memos.build
  end

  def show
    if flash[:from_practice]
      @form_words   = flash[:form_words]
      @missed_words = flash[:missed_words]
      @wrong_words  = flash[:wrong_words]
      @prev_health  = flash[:prev_health]
      @prac_time    = flash[:prac_time]
      @prev_time    = flash[:prev_time]
      render 'results'
    else
      render 'show'
    end
  end

  def edit
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      flash[:success] = "Created memo: #{@memo.name}."
      redirect_to memos_path
    else
      render 'new'
    end
  end

  def update
    @memo.best_time = nil unless @memo.practice_disabled
    if @memo.update_attributes(memo_params)
      flash[:success] = "Updated memo: #{@memo.name}."
      redirect_to memos_path
    else
      render 'edit'
    end
  end

  def destroy
    @memo.destroy
    redirect_to memos_url
  end

  def practice
    form_words  = parse_form_words
    time        = params[:time].to_f
    memo_words  = @memo.word_list.split(/\r?\n/)

    accepted_words  = []
    accepted_words  = @memo.accepted_words.split(/\r?\n/) unless @memo.accepted_words.blank?
    missed_words    = memo_words - form_words

    wrong_words  = form_words - memo_words
    wrong_words -= accepted_words

    total_errors = compute_total_errors(missed_words, wrong_words)

    previous_health = health(@memo)
    previous_time   = @memo.best_time

    @memo.health_decay += health_inc(@memo, total_errors).day unless previous_health == 100
    @memo.num_practices += 1
    @memo.best_time = time if within_acceptable_error_margin(wrong_words, missed_words) and (previous_time.nil? or previous_time > time)

    if @memo.save
      flash[:from_practice] = true
      flash[:form_words]    = form_words
      flash[:missed_words]  = missed_words
      flash[:wrong_words]   = wrong_words
      flash[:prev_health]   = previous_health
      flash[:prac_time]     = time
      flash[:prev_time]     = previous_time
      redirect_to @memo
    else
      flash[:error] = "Could not save results from practice session"
      redirect_to memos_path
    end
  end


  private

    def parse_form_words()
      params[:message].upcase
                      .tr(" ", "\n")
                      .tr("å-ü", "Å-Ü")
                      .split(/\r?\n/)
                      .uniq
                      .reject { |w| w == "" }
    end

    def compute_total_errors(missed, wrong)
      total = missed.count + wrong.count
      return 0 unless total >= acceptable_error_margin
      total - acceptable_error_margin()
    end

    def memo_params
      params.require(:memo).permit(:name, :hints, :word_list, :accepted_words, :practice_disabled)
    end

    def correct_user
      @memo = current_user.memos.find_by(id: params[:id])
      if @memo.nil?
        flash[:error] = "Could not find memo"
        redirect_to root_url
      end
    end

    def ordered_by_health()
      current_user.memos.sort_by { |m| if m.practice_disabled then 101 else health m end }
    end

end
