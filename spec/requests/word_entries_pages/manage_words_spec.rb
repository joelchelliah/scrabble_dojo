require 'spec_helper'

describe "Admin > Manage words:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "DABB", length: 4, letters: "ABBD", first_letter: "D")
  end

  context "When user is not logged in" do
    before { visit word_entries_path }

    it { should be_the_login_page }
  end

  context "When regular user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit word_entries_path
    end
    after { user.destroy }

    it { should be_the_home_page }
  end

  context "When admin user is logged in" do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      log_in user
      visit word_entries_path
    end
    after { user.destroy }

    it { should be_the_manage_words_page }

    describe "and looks up a word that doesn't exist" do
      before { word_search "abcd" }

      it { should be_the_add_word_page_for "ABCD" }

      describe "and then cancels" do
        before { click_link 'Cancel' }

        it { should be_the_manage_words_page }
      end

      describe "and then chooses to add the word" do
        before { click_button 'Add' }

        it "Should add the word" do
          expect(page).to be_the_manage_words_page
          expect(page).to have_success_message 'Added word: ABCD.'
          expect(WordEntry.where(word: 'ABCD').first).not_to eq(nil)
        end
        
        describe "and then looks up the same word again" do
          before { word_search "abcd" }
          
          it { should be_the_remove_word_page_for "ABCD" }
        end
      end
    end

    describe "and looks up a word that exists" do
      before { word_search "dabb" }

      it { should be_the_remove_word_page_for "DABB" }

      describe "and then cancels" do
        before { click_link 'Cancel' }

        it { should be_the_manage_words_page }
      end

      describe "and then chooses to remove the word" do
        before { click_link 'Remove' }

        it "Should remove the word" do
          expect(page).to be_the_manage_words_page
          expect(page).to have_success_message 'Removed word: DABB.'
          expect(WordEntry.where(word: 'DABB').first).to eq(nil)
        end
      end
    end
  end
end