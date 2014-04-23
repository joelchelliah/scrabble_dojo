require 'spec_helper'

describe "Word pages:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "APEKATT", length: 7)
    FactoryGirl.create(:word_entry, word: "KATTUNGE", length: 8)
    FactoryGirl.create(:word_entry, word: "SKATTEN", length: 7)
  end

  describe "Visit the stems page without being logged in" do
    before { visit stems_path }

    it { should go_to_the_login_page }
  end

  describe "Visit the stems page while logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit stems_path
    end
    after { user.destroy }

    it { should have_title 'Word stems' }
    it { should have_headings 'Words', 'Stems' }
    it { should have_selector 'input' }
    it { should have_selector 'select' }

    describe "and look for words containing a poor stem" do
      before do
        fill_in "word", with: "ABCD"
        click_button "Search"
      end

      it { should have_content 'Found 0 words containing ABCD' }
    end

    describe "and look for words containing the giving stem as a prefix" do
      before do
        fill_in "word", with: "katt"
        select "Prefix", from: "option"
        click_button "Search"
      end

      it { should have_content 'Found 1 word containing KATT as a prefix' }
      it { should have_content 'KATTUNGE' }

      it { should_not have_content 'APEKATT' }
      it { should_not have_content 'SKATTEN' }
    end

    describe "and look for words containing the giving stem as a suffix" do
      before do
        fill_in "word", with: "katt"
        select "Suffix", from: "option"
        click_button "Search"
      end

      it { should have_content 'Found 1 word containing KATT as a suffix' }
      it { should have_content 'APEKATT' }

      it { should_not have_content 'KATTUNGE' }
      it { should_not have_content 'SKATTEN' }
    end

    describe "and look for words containing the giving stem as either a prefix or a suffix" do
      before do
        fill_in "word", with: "katt"
        select "Prefix or suffix", from: "option"
        click_button "Search"
      end

      it { should have_content 'Found 2 words containing KATT as either a prefix or a suffix' }
      it { should have_content 'KATTUNGE' }
      it { should have_content 'APEKATT' }

      it { should_not have_content 'SKATTEN' }
    end

    describe "and look for words containing the giving stem anywhere in the word" do
      before do
        fill_in "word", with: "katt"
        select "Contains", from: "option"
        click_button "Search"
      end

      it { should have_content 'Found 3 words containing KATT' }
      it { should have_content 'KATTUNGE' }
      it { should have_content 'APEKATT' }
      it { should have_content 'SKATTEN' }
    end
  end
end