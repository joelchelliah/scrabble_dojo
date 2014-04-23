require 'spec_helper'

describe "Find words > Word stems:" do

  subject { page }
  before do
    FactoryGirl.create(:word_entry, word: "APEKATT", length: 7)
    FactoryGirl.create(:word_entry, word: "KATTUNGEN", length: 9)
    FactoryGirl.create(:word_entry, word: "SKATTENE", length: 8)
  end

  context "when user is not logged in" do
    before { visit stems_path }

    it { should be_the_login_page }
  end

  context "when user is logged in" do
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

      it "Should only find words prefixed by KATT" do
        expect(page).to have_content 'Found 1 word prefixed by KATT'
        expect(page).to have_content 'KATTUNGEN'
        expect(page).not_to have_content 'APEKATT'
        expect(page).not_to have_content 'SKATTENE'
      end
    end

    describe "and looks for words suffixed by KATT" do
      before { stem_search 'katt', 'Suffix' }

      it "Should only find words suffixed by KATT" do
        expect(page).to have_content 'Found 1 word suffixed by KATT'
        expect(page).to have_content 'APEKATT'
        expect(page).not_to have_content 'KATTUNGEN'
        expect(page).not_to have_content 'SKATTENE'
      end
    end

    describe "and looks for words prefixed or suffixed by KATT" do
      before { stem_search 'katt', 'Prefix or suffix' }

      it "Should only find words either prefixed or suffixed by KATT" do
        expect(page).to have_content 'Found 2 words affixed by KATT'
        expect(page).to have_content 'KATTUNGEN'
        expect(page).to have_content 'APEKATT'
        expect(page).not_to have_content 'SKATTENE'
      end
    end

    describe "and looks for words containing KATT" do
      before { stem_search 'katt', 'Contains' }

      it "Should only find words either prefixed or suffixed by KATT" do
        expect(page).to have_content 'Found 3 words containing KATT'
        expect(page).to have_content 'KATTUNGEN'
        expect(page).to have_content 'APEKATT'
        expect(page).to have_content 'SKATTENE'
      end
    end

    describe "and sets maximum word length to 7" do
      before { select '7 letters', from: "max_length" }

      describe "and looks for words prefixed or suffixed by KATT" do
        before { stem_search 'katt', 'Prefix or suffix' }

        it "Should only find words of length less or equal to 7" do
          expect(page).to have_content 'Found 1 word affixed by KATT, with a maximum length of 7'
          expect(page).to have_content 'APEKATT'
          expect(page).not_to have_content 'KATTUNGEN'
          expect(page).not_to have_content 'SKATTENE'
        end
      end
    end

    describe "and sets maximum word length to 8" do
      before { select '8 letters', from: "max_length" }

      describe "and looks for words containing KATT" do
        before { stem_search 'katt', 'Contains' }

        it "Should only find words of length less or equal to 8" do
          expect(page).to have_content 'Found 2 words containing KATT, with a maximum length of 8'
          expect(page).to have_content 'APEKATT'
          expect(page).to have_content 'SKATTENE'
          expect(page).not_to have_content 'KATTUNGEN'
        end
      end
    end
  end
end