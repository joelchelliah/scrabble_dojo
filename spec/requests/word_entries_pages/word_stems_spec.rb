require 'spec_helper'

describe "Find words > Word stems:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "APEKATT", length: 7)
    FactoryGirl.create(:word_entry, word: "KATTUNGE", length: 8)
    FactoryGirl.create(:word_entry, word: "SKATTEN", length: 7)
  end

  describe "when user is not logged in" do
    before { visit stems_path }

    it { should be_the_login_page }
  end

  describe "when user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit stems_path
    end
    after { user.destroy }

    it { should be_the_word_stems_page }

    describe "and looks for words containing ABCD (bad stem)" do
      before { stem_search 'abcd' }

      it { should have_content 'Found 0 words containing ABCD' }
    end

    describe "and looks for words prefixed by KATT" do
      before { stem_search 'katt', 'Prefix' }

      it "should only find words prefixed by KATT" do
        expect(page).to have_content 'Found 1 word containing KATT as a prefix'
        expect(page).to have_content 'KATTUNGE'
        expect(page).not_to have_content 'APEKATT'
        expect(page).not_to have_content 'SKATTEN'
      end
    end

    describe "and looks for words suffixed by KATT" do
      before { stem_search 'katt', 'Suffix' }

      it "should only find words suffixed by KATT" do
        expect(page).to have_content 'Found 1 word containing KATT as a suffix'
        expect(page).to have_content 'APEKATT'
        expect(page).not_to have_content 'KATTUNGE'
        expect(page).not_to have_content 'SKATTEN'
      end
    end

    describe "and looks for words prefixed or suffixed by KATT" do
      before { stem_search 'katt', 'Prefix or suffix' }

      it "should only find words either prefixed or suffixed by KATT" do
        expect(page).to have_content 'Found 2 words containing KATT as either a prefix or a suffix'
        expect(page).to have_content 'KATTUNGE'
        expect(page).to have_content 'APEKATT'
        expect(page).not_to have_content 'SKATTEN'
      end
    end

    describe "and looks for words containing KATT" do
      before { stem_search 'katt', 'Contains' }

      it "should only find words either prefixed or suffixed by KATT" do
        expect(page).to have_content 'Found 3 words containing KATT'
        expect(page).to have_content 'KATTUNGE'
        expect(page).to have_content 'APEKATT'
        expect(page).to have_content 'SKATTEN'
      end
    end
  end
end