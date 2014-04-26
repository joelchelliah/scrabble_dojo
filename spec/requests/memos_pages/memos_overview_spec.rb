require 'spec_helper'

describe "Memos overview:" do
  subject { page }

  context "when user is not logged in" do
    before { visit memos_path }

    it { should be_the_login_page }
  end

  context "when user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before { log_in user }
    after { user.destroy }

    context "and has no memos" do
      before { visit memos_path }

      it { should be_the_memos_overview_page }
      it { should_not have_memos_overview_buttons }
      it { should have_link 'Create a memo', href: new_memo_path }
    end

    context "and already has some memos" do
      let!(:memo_A) { FactoryGirl.create(:memo, user: user, name: "memo A", health_decay: Time.now - 2.day) }
      let!(:memo_B) { FactoryGirl.create(:memo, user: user, name: "memo B", health_decay: Time.now - 4.day, practice_disabled: true) }
      let!(:memo_C) { FactoryGirl.create(:memo, user: user, name: "memo C", health_decay: Time.now - 3.day) }
      before { visit memos_path }

      it { should be_the_memos_overview_page }
      it { should have_memos_overview_buttons }
      it "Should show existing memos ordered by name" do
        expect(page.body =~ />#{memo_A.name}</).to be < (page.body =~ />#{memo_B.name}</)
        expect(page.body =~ />#{memo_B.name}</).to be < (page.body =~ />#{memo_C.name}</)
      end

      describe "and clicks on 'Sort by health'" do
        before { click_link 'Sort by health'}      

        it "Should show existing memos ordered by health" do
          expect(page.body =~ />#{memo_C.name}</).to be < (page.body =~ />#{memo_A.name}</)
          expect(page.body =~ />#{memo_A.name}</).to be < (page.body =~ />#{memo_B.name}</)
        end
      end

      describe "and clicks on 'New memo'" do
        before { click_link 'New memo'}

        it { should be_the_create_memo_page }
      end

      describe "and clicks the first 'Update' link" do
        before { first('.right-column').click_link('', match: :first) }

        it { should be_the_update_memo_page_for memo_A }
      end

      describe "and clicks on 'Revise weakest memo'" do
        before { click_link 'Revise weakest memo'}

        it { should be_the_revise_memo_page_for memo_C }
      end
    end
  end
end