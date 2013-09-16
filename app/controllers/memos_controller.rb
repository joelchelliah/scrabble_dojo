class MemosController < ApplicationController
  before_action :set_memo, only: [:show, :edit, :update, :destroy, :practice, :results]

  def index
    sort_attr = (flash[:sort_by] or :name)
    if sort_attr == :count
      @memos = Memo.all.sort_by { |m| m.word_list.size }
    else
      @memos = Memo.all.sort_by { |m| m.send sort_attr }
    end
  end

  def by_health
    flash[:sort_by] = :health_decay
    redirect_to memos_path
  end

  def by_word_count
    flash[:sort_by] = :count
    redirect_to memos_path
  end

  def revise_weakest
    redirect_to Memo.all.sort_by { |m| m.health_decay }.first
  end

  def show
  end

  # GET /memos/new
  def new
    @memo = Memo.new
  end

  # GET /memos/1/edit
  def edit
  end

  # POST /memos
  # POST /memos.json
  def create
    @memo = Memo.new(memo_params)
    @memo.health_decay = Time.now - 10.day unless @memo.health_decay
    @memo.word_list = parse_form_words(@memo.word_list).join("\n") if @memo.word_list

    respond_to do |format|
      if @memo.save
        flash[:notice] = "Created memo: #{@memo.name}."
        format.html { redirect_to memos_path }
        format.json { render action: 'show', status: :created, location: @memo }
      else
        format.html { render action: 'new' }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memos/1
  # PATCH/PUT /memos/1.json
  def update
    @memo.word_list = parse_form_words(@memo.word_list).join("\n") if @memo.word_list
    respond_to do |format|
      if @memo.update(memo_params)
        flash[:notice] = "Updated memo: #{@memo.name}."
        format.html { redirect_to memos_path }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memos/1
  # DELETE /memos/1.json
  def destroy
    @memo.destroy
    respond_to do |format|
      format.html { redirect_to memos_url }
      format.json { head :no_content }
    end
  end

  # PATCH /memos/1/practice
  def practice
    form_words = parse_form_words params[:message]
    memo_words = @memo.word_list.split(/\r?\n/).uniq

    missed_words = memo_words - form_words
    wrong_words = form_words - memo_words
    
    decay_diff = ((Time.now - @memo.health_decay) / 1.day).to_i
    num_errors = missed_words.count + wrong_words.count

    previous_health = 100 - (3 * decay_diff)
    health_inc = (decay_diff / (1 + num_errors)).to_i    # converting to integer to round it down

    @memo.health_decay += health_inc.day                 # converting back to day before adding
    @memo.num_practices += 1
    respond_to do |format|
      if @memo.save
        flash[:from_practice] = true
        flash[:form_words] = form_words
        flash[:missed_words] = missed_words
        flash[:wrong_words] = wrong_words
        flash[:prev_health] = previous_health
        format.html { redirect_to results_memo_path @memo }
        format.json { head :no_content }
      else
        flash[:notice] = "Something went wrong."
        format.html { redirect_to memos_path }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /memos/1/results
  def results
    if flash[:from_practice]
      @form_words = flash[:form_words]
      @missed_words = flash[:missed_words]
      @wrong_words = flash[:wrong_words]
      @prev_health = flash[:prev_health]

      # puts "----------------------------------"
      # puts "DEBUG"
      # puts "in results"
      # puts "entered words: #{@form_words}"
      # puts "number of missed words: #{@missed_words.count}"
      # puts "number of wrong words: #{@wrong_words.count}"
      
      # puts "previous health : #{@prev_health}"
      # puts "new health decay: #{@memo.health_decay}"

      # puts "----------------------------------"

    else
      respond_to do |format|
        format.html { redirect_to @memo }
        format.json { head :no_content }
      end
    end
  end

  private

    def parse_form_words(form_words)
      form_words.tr(" ", "\n")
                .tr("å-ü", "Å-Ü")
                .split(/\r?\n/)
                .uniq
                .map {|w| w.upcase }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_memo
      @memo = Memo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def memo_params
      params.require(:memo).permit(:name, :hints, :word_list)
    end
end
