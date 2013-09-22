class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy, :practice, :results_of]

  def index
    @memos = current_user.memos
  end

  def by_health
    @memos = current_user.memos.by_health
    render 'index'
  end

  def by_word_count
    @memos = current_user.memos.sort_by { |m| -m.word_list.size }
    render 'index'
  end

  def revise_weakest
    redirect_to current_user.memos.weakest
  end

  def show
  end

  def new
    @memo = current_user.memos.build
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
    form_words = parse_form_words
    memo_words = @memo.word_list.split(/\r?\n/).uniq

    missed_words = memo_words - form_words
    wrong_words = form_words - memo_words
    
    decay_diff = ((Time.now - @memo.health_decay) / 1.day).to_i
    num_errors = missed_words.count + wrong_words.count

    previous_health = 100 - (3 * decay_diff)
    health_inc = (decay_diff / (1 + num_errors)).to_i    # converting to integer to round it down

    @memo.health_decay += health_inc.day                 # converting back to day before adding
    @memo.num_practices += 1

    if @memo.save
      flash[:from_practice] = true
      flash[:form_words] = form_words
      flash[:missed_words] = missed_words
      flash[:wrong_words] = wrong_words
      flash[:prev_health] = previous_health
      redirect_to results_of_memo_path @memo
    else
      flash[:error] = "Could not save results from practice session"
      redirect_to memos_path
    end
  end

  def results_of
    if flash[:from_practice]
      @form_words = flash[:form_words]
      @missed_words = flash[:missed_words]
      @wrong_words = flash[:wrong_words]
      @prev_health = flash[:prev_health]
    else
      redirect_to @memo
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

    def memo_params
      params.require(:memo).permit(:name, :hints, :word_list)
    end

    def correct_user
      @memo = current_user.memos.find_by(id: params[:id])
      if @memo.nil?
        flash[:error] = "Could not find memo"
        redirect_to root_url
      end
    end
end
