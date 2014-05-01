class WordEntriesController < ApplicationController
  before_action :set_word_entry, only: [:show, :destroy]
  before_action :logged_in_user, only: [:show, :new, :create, :destroy, :index, :look_up, :search, :stems]
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


  # Search words #
  ################

  def search
    @word = params[:word]
    @word_entries = []
    unless @word.blank?
      @word =   @word.upcase.tr("å-ü", "Å-Ü").tr(" ", ".")
      letters = @word.split(//).sort

      if get_num_blank_tiles(letters) > 2
        flash[:error] = "Too many blank tiles entered in search: [#{@word}]. The maximum allowed is two."
        redirect_to search_path
      elsif get_num_blank_tiles(letters) >= 1
        @word_entries = find_words_with_blank_tiles(@word, get_num_blank_tiles(letters) == 2)
      else
        @word_entries = WordEntry.where(letters: letters.join)
      end
    end
    @word_entries = @word_entries.sort_by { |w| w.word }
  end


  # Word stems #
  ##############

  def stems
    option_prefix = 'prefix'
    option_suffix = 'suffix'
    option_contains = 'contains'

    @word = params[:word]
    @word_entries = []
    @option = params[:option] || option_contains
    @max_length = params[:max_length] || 15
    unless @word.blank?
      @word = @word.upcase.tr("å-ü", "Å-Ü")
      condition = "length > :lmin AND length >= 5 AND length <= :lmax AND word LIKE :s"
      if @option == option_contains
        @word_entries = WordEntry.where(condition, lmin: @word.length, lmax: @max_length, s: "%#{@word}%")
      else
        @word_entries += WordEntry.where(condition, lmin: @word.length, lmax: @max_length, s: "#{@word}%") unless @option == option_suffix
        @word_entries += WordEntry.where(condition, lmin: @word.length, lmax: @max_length, s: "%#{@word}") unless @option == option_prefix
      end
    end
    @word_entries = @word_entries.sort_by { |w| w.length }
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

    def get_num_blank_tiles(letters)
      letters.find_all { |t| t == "." }.size
    end

    def find_words_with_blank_tiles(word, has_two_blank_tiles)
      word_entries = []
      alphabet().each do |first_blank_sub|
        word_with_first_blank_replaced = word.sub(".", first_blank_sub)
        if has_two_blank_tiles
          alphabet().each do |second_blank_sub|
            word_with_second_blank_replaced = word_with_first_blank_replaced.sub(".", second_blank_sub)
            word_entries += WordEntry.where(letters: word_with_second_blank_replaced.split(//).sort.join)
          end
        else
          word_entries += WordEntry.where(letters: word_with_first_blank_replaced.split(//).sort.join)
        end
      end
      word_entries.uniq
    end

    def alphabet()
      ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
       "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Æ", "Ø", "Å", "Ü"]
    end
end
