require 'spec_helper'

describe "Memos" do
	subject { page }

	describe "create new memo" do
		before { visit new_memo_path }

		it { should have_title 'Scrabble Dojo' }
		it { should have_selector 'h1', text: 'Memo' }
		it { should have_selector 'h2', text: 'Create' }
		it { should have_selector 'input' }
		it { should have_selector 'textarea' }
		it { should have_link 'Back', href: memos_path }

		let(:submit) { "Save" }

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

	describe "memo overview" do
		before { visit memos_path }

		it { should have_title 'Scrabble Dojo' }
		it { should have_selector 'h1', text: 'Memo' }
		it { should have_selector 'h2', text: 'Overview' }
		it { should have_link 'New memo', href: new_memo_path }
		it { should have_link 'Sort by name', href: memos_path }
		it { should have_link 'Sort by health', href: by_health_memos_path }
		it { should have_link 'Sort by word count', href: by_word_count_memos_path }
		it { should have_link 'Revise weakest memo', href: revise_weakest_memos_path }
	end
end
