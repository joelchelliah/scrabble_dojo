require 'spec_helper'

describe "Find words > Word search:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "DABB", length: 4, letters: "ABBD", first_letter: "D")
    FactoryGirl.create(:word_entry, word: "KABB", length: 4, letters: "ABBK", first_letter: "K")
    FactoryGirl.create(:word_entry, word: "KIBB", length: 4, letters: "BBIK", first_letter: "K")
    FactoryGirl.create(:word_entry, word: "SEIGARN", length: 7, letters: "AEGINRS", first_letter: "S")
    FactoryGirl.create(:word_entry, word: "SIREGNA", length: 7, letters: "AEGINRS", first_letter: "S")
    FactoryGirl.create(:word_entry, word: "SIGAREN", length: 7, letters: "AEGINRS", first_letter: "S")
  end

  describe "when user is not logged in" do
    before { visit search_path }

    it { should be_the_login_page }
  end

  describe "when user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit search_path
    end
    after { user.destroy }

    it { should be_the_word_search_page }

    describe "and searches for a word that doesn't exist" do
      before { word_search "abcd" }

      it "should not find any results" do expect(page).to have_content 'Found 0 anagrams for ABCD' end
    end

    describe "and search for a word that exists" do
      before { word_search "dabb" }

      it "should find the word" do expect(page).to have_content 'Found 1 anagram for DABB' end
    end

    describe "and searches for an anagram of existing words" do
      before { word_search "SEIGANR" }

      it "should find all possible anagrams of the given word" do
        expect(page).to have_content 'Found 3 anagrams for SEIGANR'
        expect(page).to have_content 'SEIGARN'
        expect(page).to have_content 'SIREGNA'
        expect(page).to have_content 'SIGAREN'
      end
    end

    describe "and enters a search with a blank tile" do
      before { word_search "abb." }

      it "should find anagrams considering all possible values for the blank tile" do
        expect(page).to have_content 'Found 2 anagrams for ABB.'
        expect(page).to have_content 'DABB'
        expect(page).to have_content 'KABB'
      end
    end

    describe "and enters a search with two blank tiles" do
      before { word_search ".bb." }

      it "should find anagrams considering all possible values for both blank tiles" do
        expect(page).to have_content 'Found 3 anagrams for .BB.'
        expect(page).to have_content 'DABB'
        expect(page).to have_content 'KABB'
        expect(page).to have_content 'KIBB'
      end
    end

    describe "and enters a search with two blank tiles using spaces" do
      before { word_search "bb  " }

      it "should find anagrams considering all possible values for both blank tiles" do
        expect(page).to have_content 'Found 3 anagrams for BB..'
        expect(page).to have_content 'DABB'
        expect(page).to have_content 'KABB'
        expect(page).to have_content 'KIBB'
      end
    end

    describe "and enters a search with three blank tiles" do
      before { word_search "b. ." }

      it "should not perform a search" do
        expect(page).not_to have_content 'Found 3 anagrams for B...'
        expect(page).to have_error_message 'Too many blank tiles entered in search: [B...]. The maximum allowed is two.'
      end
    end
  end
end