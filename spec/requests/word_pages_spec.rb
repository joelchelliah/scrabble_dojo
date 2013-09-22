require 'spec_helper'

describe "Word pages" do

  subject { page }

  describe "short words" do
  	before do
  		FactoryGirl.create(:word_entry, word: "AB", length: 2, first_letter: "A")
  		FactoryGirl.create(:word_entry, word: "COR", length: 3, first_letter: "C")
  		FactoryGirl.create(:word_entry, word: "WEBB", length: 4, first_letter: "W")
  	end

  	describe "of length 2" do
  		before { visit word_length_path(2) }

  		it { should have_title('Short words') }
      it { should have_headings 'Word', 'Two letter words' }
  		it { should have_short_words_buttons }
  		it { should have_selector "h3", text:"A" }
  		it { should have_content "AB" }
  	end

  	describe "of length 3" do
  		before { visit word_length_path(3) }

  		it { should have_title('Short words') }
      it { should have_headings 'Word', 'Three letter words' }
      it { should have_short_words_buttons }
      it { should have_selector "h3", text:"C" }
  		it { should have_content "COR" }
  	end

  	describe "of length 4" do
  		before { visit word_length_path(4) }

  		it { should have_title('Short words') }
      it { should have_headings 'Word', 'Four letter words' }
      it { should have_short_words_buttons }
      it { should have_selector "h3", text:"W" }
  		it { should have_content "WEBB" }
  	end

  	describe "with C" do
  		before { visit short_words_with_path("C") }

  		it { should have_title('Short words') }
      it { should have_headings 'Word', 'Short words with C' }
      it { should have_short_words_buttons }
      it { should have_selector "h3", text:"C" }
  		it { should have_content "COR" }
  	end

  	describe "with W" do
  		before { visit short_words_with_path("W") }

  		it { should have_title('Short words') }
      it { should have_headings 'Word', 'Short words with W' }
      it { should have_short_words_buttons }
      it { should have_selector "h3", text:"W" }
  		it { should have_content "WEBB" }
  	end
  end
end