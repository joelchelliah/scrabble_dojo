require 'spec_helper'

describe "Word pages:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "DABB", length: 4, letters: "ABBD", first_letter: "D")
  end

  describe "Visit manage-words page without being logged in" do
    before { visit word_entries_path }

    it { should go_to_the_login_page }
  end

  describe "Visit manage-words page while logged in as regular user" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit word_entries_path
    end
    after { user.destroy }

    it { should go_to_the_home_page }
  end

  describe "Visit manage-words page while logged in as admin" do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      log_in user
      visit word_entries_path
    end
    after { user.destroy }

    it { should have_title 'Words' }
    it { should have_headings 'Words', 'Manage' }
    it { should have_selector 'input' }

    describe "and look up a word that doesn't exist" do
      before do
        fill_in "word", with: "ABCD"
        click_button "Search"
      end

      it { should have_content 'The word ABCD was not found. Do you want to add it?' }
      it { should have_headings 'Words', 'Add ABCD?' }
      it { should have_button 'Add' }
      it { should have_link 'Cancel' }

      describe "and then cancel" do
        before { click_link 'Cancel' }

        it { should have_headings 'Words', 'Manage' }
        it { should_not have_flash_message_of_type 'success' }
      end

      describe "and then choose to add the word" do
        before { click_button 'Add' }

        it { should have_headings 'Words', 'Manage' }
        it { should have_success_message 'Added word: ABCD.'}

        describe "and then look look up the same word again" do
          before do
            fill_in "word", with: "ABCD"
            click_button "Search"
          end
          
          it { should have_content 'The word ABCD was found. Do you want to remove it?' }
          it { should have_headings 'Words', 'Remove ABCD?' }
          it { should have_link 'Remove' }
          it { should have_link 'Cancel' }
        end
      end
    end

    describe "and look up a word that exists" do
      before do
        fill_in "word", with: "DABB"
        click_button "Search"
      end

      it { should have_content 'The word DABB was found. Do you want to remove it?' }
      it { should have_headings 'Words', 'Remove DABB?' }
      it { should have_link 'Remove' }
      it { should have_link 'Cancel' }

      describe "and then cancel" do
        before { click_link 'Cancel' }

        it { should have_headings 'Words', 'Manage' }
        it { should_not have_flash_message_of_type 'success' }
      end

      describe "and then choose to remove the word" do
        before { click_link 'Remove' }

        it { should have_headings 'Words', 'Manage' }
        it { should have_success_message 'Removed word: DABB.'}
      end
    end
  end
end