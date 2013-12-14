class WordEntriesController < ApplicationController
  before_action :set_word_entry, only: [:show, :destroy]
  before_action :admin_user,     only: [:show, :new, :create, :destroy, :index, :look_up]

  # Short words #
  ###############

  def word_length
    @length = params[:len]
    if %w(2 3 4).include? @length
      @word_entries = WordEntry.word_length @length
      @word_entries = sort_list_correctly_by_field(@word_entries, :word)
      render 'short_words'
    else
      redirect_to root_url
    end
  end

  def short_words_with
    @letter = params[:letter]
    if %w(c C w W q Q z Z x X).include? @letter
      @word_entries = WordEntry.short_words.select { |entry| entry.word.include? @letter.upcase }
      @word_entries = sort_list_correctly_by_field(@word_entries, :word)
      render 'short_words'
    else
      redirect_to root_url
    end
  end


  # Manage words #
  ################

  def index
  end

  def look_up
    w = params[:word]
    redirect_to word_entries_path if w.blank?
    w = w.upcase.tr("å-ü", "Å-Ü")
    
    word_entry = WordEntry.find_by(word: w)

    if word_entry
      redirect_to word_entry
    else
      flash[:from_lookup] = true
      flash[:new_word] = w
      redirect_to new_word_entry_path
    end
  end

  def show
  end

  def new
    if flash[:from_lookup]
      w = flash[:new_word]
      @word_entry = WordEntry.new(word: w, letters: w.split(//).sort.join, length: w.length, first_letter: w.split(//).first)
    else
      redirect_to word_entries_path
    end
  end

  def create
    @word_entry = WordEntry.new(word_entry_params)
    if @word_entry.save
      flash[:success] = "Added word: #{@word_entry.word}."
      redirect_to word_entries_path
    else
      flash[:error] = "Could not add word: #{@word_entry.word}."
      redirect_to word_entries_path
    end
  end

  def destroy
    word = @word_entry.word
    @word_entry.destroy
    flash[:success] = "Removed word: #{word}."
    redirect_to word_entries_path
  end


  private

    def set_word_entry
      @word_entry = WordEntry.find(params[:id])
    end

    def word_entry_params
      params.require(:word_entry).permit(:word, :letters, :length, :first_letter)
    end
end
