require 'spec_helper'

describe "Memos create:" do
  subject { page }

  context "when user is not logged in" do
    before { visit new_memo_path }

    it { should be_the_login_page }
  end

  context "when user is logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Create" }
    before do
      log_in user
      visit new_memo_path
    end
    after { user.destroy }

    it { should be_the_create_memo_page }
    it { should hide_advanced_options }

    it "Should not allow creating memo" do
      expect { click_button submit }.not_to change(Memo, :count)
    end

    describe "and fills out name field" do
      before { fill_in "memo_name" , with: "A3" }
      
      it "Should not allow creating memo" do
        expect { click_button submit }.not_to change(Memo, :count)
      end
    end

    describe "and fills out all fields" do
      before { fill_out_memo_fields "A3", "ABC adl\r\næøå", "hintsæøå\r\n" }
      
      it "Should allow creating memo" do
        expect { click_button submit }.to change(Memo, :count).by(1)
      end

      describe "and after creating the memo" do
        before { click_button submit }

        it { should be_the_memos_overview_page }
        it { should have_success_message 'Created memo: A3' }

        describe "and then when going to the update page for that memo" do
          before { visit edit_memo_path(Memo.first) }
          
          it "Should have the fields filled with correct values" do
            expect(page).to have_content "ABC\r\nADL\r\nÆØÅ"
            expect(page).to have_content "HINTSÆØÅ"
          end
        end
      end
    end

    describe "and chooses advanced options" do
      before { click_link "Advanced options" }

      it { should show_advanced_options }
    end
  end
end