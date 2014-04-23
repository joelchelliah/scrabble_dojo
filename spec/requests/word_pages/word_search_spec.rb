require 'spec_helper'

describe "Word pages:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "DABB", length: 4, letters: "ABBD", first_letter: "D")
    FactoryGirl.create(:word_entry, word: "KABB", length: 4, letters: "ABBK", first_letter: "K")
    FactoryGirl.create(:word_entry, word: "KIBB", length: 4, letters: "BBIK", first_letter: "K")
    FactoryGirl.create(:word_entry, word: "SEIGARN", length: 7, letters: "AEGINRS", first_letter: "S")
    FactoryGirl.create(:word_entry, word: "SIREGNA", length: 7, letters: "AEGINRS", first_letter: "S")
    FactoryGirl.create(:word_entry, word: "SIGAREN", length: 7, letters: "AEGINRS", first_letter: "S")
  end

  describe "Visit search page without being logged in" do
    before { visit search_path }

    it { should go_to_the_login_page }
  end

  describe "Visit search page while logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit search_path
    end
    after { user.destroy }

    it { should have_title 'Word search' }
    it { should have_headings 'Words', 'Search' }
    it { should have_selector 'input' }

    describe "and search for a word that doesn't exist" do
      before do
        fill_in "word", with: "ABCD"
        click_button "Search"
      end

      it { should have_content 'Found 0 anagrams for ABCD' }
    end

    describe "and search for a word that exists" do
      before do
        fill_in "word", with: "DABB"
        click_button "Search"
      end

      it { should have_content 'Found 1 anagram for DABB' }
    end

    describe "and search for an anagram of existing words" do
      before do
        fill_in "word", with: "SEIGANR"
        click_button "Search"
      end

      it { should have_content 'Found 3 anagrams for SEIGANR' }
      it { should have_content 'SEIGARN' }
      it { should have_content 'SIREGNA' }
      it { should have_content 'SIGAREN' }
    end

    describe "and enter a search with a blank tile" do
      before do
        fill_in "word", with: "abb."
        click_button "Search"
      end

      it { should have_content 'Found 2 anagrams for ABB.' }
      it { should have_content 'DABB' }
      it { should have_content 'KABB' }
    end

    describe "and enter a search with two blank tiles (periods)" do
      before do
        fill_in "word", with: "bb.."
        click_button "Search"
      end

      it { should have_content 'Found 3 anagrams for BB..' }
      it { should have_content 'DABB' }
      it { should have_content 'KABB' }
      it { should have_content 'KIBB' }
    end

    describe "and enter a search with two blank tiles (spaces)" do
      before do
        fill_in "word", with: "bb  "
        click_button "Search"
      end

      it { should have_content 'Found 3 anagrams for BB..' }
      it { should have_content 'DABB' }
      it { should have_content 'KABB' }
      it { should have_content 'KIBB' }
    end
  end
end