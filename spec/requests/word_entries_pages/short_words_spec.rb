require 'spec_helper'

describe "Short words:" do

  subject { page }
	before do
		FactoryGirl.create(:word_entry, word: "AB", length: 2, first_letter: "A")
    FactoryGirl.create(:word_entry, word: "WC", length: 2, first_letter: "W")
		FactoryGirl.create(:word_entry, word: "COR", length: 3, first_letter: "C")
    FactoryGirl.create(:word_entry, word: "PEN", length: 3, first_letter: "P")
    FactoryGirl.create(:word_entry, word: "BOWL", length: 4, first_letter: "B")
	end

	describe "when visiting the 2 letter words page" do
		before { visit word_length_path(2) }

    it "Should show all 2 letter words" do
      expect(page).to be_the_short_words_page_for 'Two letter words'
      expect(page).to have_these_short_words %w(AB WC)
      expect(page).not_to have_these_short_words %w(COR PEN BOWL)
    end
	end

	describe "when visiting the 3 letter words page" do
		before { visit word_length_path(3) }

    it "Should show all 3 letter words" do
      expect(page).to be_the_short_words_page_for 'Three letter words'
      expect(page).to have_these_short_words %w(COR PEN)
      expect(page).not_to have_these_short_words %w(AB WC BOWL)
    end
	end

	describe "when visiting the 4 letter words page" do
		before { visit word_length_path(4) }

    it "Should show all 4 letter words" do
      expect(page).to be_the_short_words_page_for 'Four letter words'
      expect(page).to have_these_short_words %w(BOWL)
      expect(page).not_to have_these_short_words %w(AB WC COR PEN)
    end
	end

	describe "when visiting the C words page" do
		before { visit short_words_with_path("C") }

    it "Should show all short C words" do
      expect(page).to be_the_short_words_page_for 'Short words with C'
      expect(page).to have_these_short_words %w(WC COR)
      expect(page).not_to have_these_short_words %w(AB PEN BOWL)
    end
	end

	describe "when visiting the W words page" do
		before { visit short_words_with_path("W") }

    it "Should show all short W words" do
      expect(page).to be_the_short_words_page_for 'Short words with W'
      expect(page).to have_these_short_words %w(WC BOWL)
      expect(page).not_to have_these_short_words %w(AB COR PEN)
    end
	end

  context "when words contain Norwegian characters" do
    before do
      FactoryGirl.create(:word_entry, word: "TACT", length: 4, first_letter: "T")
      FactoryGirl.create(:word_entry, word: "TÆCT", length: 4, first_letter: "T")
      FactoryGirl.create(:word_entry, word: "TØCT", length: 4, first_letter: "T")
      FactoryGirl.create(:word_entry, word: "TÅCT", length: 4, first_letter: "T")
    end

    describe "and when retrieving words by length" do
      before { visit word_length_path(4) }

      it "Should show the words in the correct order" do
        expect(page).to have_content "TACT TÆCT TØCT TÅCT"
      end
    end

    describe "and when retrieving words by letter" do
      before { visit short_words_with_path("C") }

      it "Should show the words in the correct order" do
        expect(page).to have_content "TACT TÆCT TØCT TÅCT"
      end
    end
  end
end