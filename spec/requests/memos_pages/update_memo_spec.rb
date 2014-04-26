require 'spec_helper'

describe "Memos update:" do
  subject { page }

  context "when user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:memo) { FactoryGirl.create(:memo, user: user) }
    let(:submit) { "Update" }
    before do
      log_in user
      visit edit_memo_path memo
    end
    after { user.destroy }

    it { should be_the_update_memo_page_for memo }
    it { should hide_advanced_options }

    describe "and empties the name field" do
      before do
        fill_in "memo_name" , with: ""
        click_button submit
      end
      
      it "Should not allow updating memo" do
        expect(page).to have_title "Update"
        expect(page).to have_content "Name can't be blank"
      end
    end

    describe "and fills out all fields with new information" do
      before do
        fill_out_memo_fields "A3", "ABC adl\r\næøå", "hintsæøå\r\n"
        click_button submit
      end

      it { should be_the_memos_overview_page }
      it { should have_success_message 'Updated memo: A3' }
    
      describe "and then when going back to the update page for that memo" do
        before { visit edit_memo_path(Memo.first) }
        
        it "Should have the fields filled with correct values" do
          expect(page).to have_content "ABC\r\nADL\r\nÆØÅ"
          expect(page).to have_content "HINTSÆØÅ"
        end
      end
    end

    describe "and chooses advanced options" do
      before { click_link "Advanced options" }

      it { should show_advanced_options }
    end
  end
end