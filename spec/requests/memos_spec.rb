require 'spec_helper'

describe "Memos" do
	subject { page }

	describe "create new memo" do
		before { visit new_memo_path }

		it { should have_title 'Scrabble Dojo' }
		it { should have_selector 'h1', text: 'Nytt Memo' }
		it { should have_selector 'label', text: 'Navn' }
		it { should have_selector 'label', text: 'Hint' }
		it { should have_selector 'label', text: 'Ordliste' }
		it { should have_link 'Tilbake', href: memos_path }

		let(:submit) { "Lagre" }

		describe "with blank name" do
			it "should not create a memo" do
				expect {click_button submit }.not_to change(Memo, :count)
			end
		end

		describe "with blank word list" do
			before { fill_in "memo_name" , with: "A3" }
			
			it "should not create a memo" do
				expect {click_button submit }.not_to change(Memo, :count)
			end
		end

		describe "with invalid word list" do
			before do
				fill_in "memo_name", with: "A3"
				fill_in "memo_word_list", with: "ABC ADL"
			end
			
			it "should not create a memo" do
				expect {click_button submit }.not_to change(Memo, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "memo_name", with: "A3"
				fill_in "memo_word_list", with: "ABC\r\nADL\r\n"
				fill_in "memo_hints", with: "ABC\r\nADL"
			end

			it "should create a memo" do
				expect {click_button submit }.to change(Memo, :count).by(1)
			end
		end
	end
end
