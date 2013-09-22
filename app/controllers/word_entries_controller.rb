class WordEntriesController < ApplicationController
  before_action :set_word_entry, only: [:edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :create, :update, :destroy]


  def word_length
    @length = params[:len]
    if %w(2 3 4).include? @length
      @word_entries = WordEntry.word_length @length
      render 'short_words'
    else
      redirect_to root_url
    end
  end

  def short_words_with
    @letter = params[:letter]
    if %w(c C w W q Q z Z x X).include? @letter
      @word_entries = WordEntry.short_words.select { |entry| entry.word.include? @letter.upcase }
      render 'short_words'
    else
      redirect_to root_url
    end
  end

  def bingos
    @word_entries = WordEntry.bingos
    render 'short_words'
  end

  def new
    @word_entry = WordEntry.new
  end

  def edit
  end

  def create
    @word_entry = WordEntry.new(word_entry_params)

    respond_to do |format|
      if @word_entry.save
        format.html { redirect_to @word_entry, notice: 'Word entry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @word_entry }
      else
        format.html { render action: 'new' }
        format.json { render json: @word_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @word_entry.update(word_entry_params)
        format.html { redirect_to @word_entry, notice: 'Word entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @word_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @word_entry.destroy
    respond_to do |format|
      format.html { redirect_to word_entry_entries_url }
      format.json { head :no_content }
    end
  end


  private

    def set_word_entry
      @word_entry = WordEntry.find(params[:id])
    end

    def word_entry_params
      params.require(:word_entry).permit(:text, :letters, :length, :first_letter)
    end
end
