require 'spec_helper'

describe "Memos revise:" do
  subject { page }

  context "when user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:memo) { FactoryGirl.create(:memo, user: user, word_list: "ABC\nADL\nAGA\nAGE\nAGG\nAGN\nAHA\nAIR", accepted_words: "ALV\nALL\nALT\nALP") }
    before do
      log_in user
      visit memo_path memo
    end
    after { user.destroy }

    it { should be_the_revise_memo_page_for memo }

    describe "and starts practice session" do
      before { click_link 'Practice' }

      it { should have_button 'Done' }

      describe "and completes practice poorly" do
        before do
          fill_in :message, with: "ABC wrong incorrect monkey pigeon african duck"
          click_button 'Done'
        end

        it { should be_the_memo_results_page_for memo }
        it { should have_content 'Health replenished: 0%' }
        it { should have_content 'You made too many mistakes.' }
        it { should have_content 'Try again with fewer mistakes...' }
        it { should have_content 'Missed (7)' }
        it { should have_content 'Wrong (6)' }
        it { should have_content 'Solution' }
      end

      describe "and completes practice perfectly" do
        let(:practice_count) { memo.num_practices }
        before do
          fill_in :message, with: "abc adl AGA age AGG agn aha air"
          click_button 'Done'
        end

        it { should be_the_memo_results_page_for memo }
        it { should have_content 'Health replenished:' }
        it { should have_content "That's a new record!" }
        it { should_not have_content 'You made too many mistakes.' }
        it { should_not have_content 'Missed' }
        it { should_not have_content 'Wrong' }
        it { should_not have_content 'Solution' }

        describe "and clicks 'Overview'" do
          before { click_link 'Overview' }

          it { should be_the_memos_overview_page }
        end

        describe "and clicks 'Revise again'" do
          before { click_link 'Revise again' }

          it { should be_the_revise_memo_page_for memo }
        end
      end

      describe "and completes practice with some acceptable words" do
        before do
          fill_in :message, with: "ABC ALV ALL ALT ALP"
          click_button 'Done'
        end

        it { should be_the_memo_results_page_for memo }
        it { should_not have_content 'Wrong' }
      end

      describe "and completes practice with some acceptable words and some wrong words" do
        before do
          fill_in :message, with: "wrong ALV incorrect ALP"
          click_button 'Done'
        end

        it { should be_the_memo_results_page_for memo }
        it { should have_content 'Wrong (2)' }
      end
    end
  end
end