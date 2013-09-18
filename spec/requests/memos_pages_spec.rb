require 'spec_helper'

describe "Memos" do
	subject { page }

	describe "memo overview" do
		before { visit memos_path }

		it { should have_title 'Memos' }
		it { should have_headings 'Memo', 'Overview' }
		it { should have_link 'New memo', href: new_memo_path }
		it { should have_link 'Sort by name', href: memos_path }
		it { should have_link 'Sort by health', href: by_health_memos_path }
		it { should have_link 'Sort by word count', href: by_word_count_memos_path }
		it { should have_link 'Revise weakest memo', href: revise_weakest_memos_path }

		describe "when clicking on 'New memo'" do
			before { click_link 'New memo'}

			it { should have_title 'New memo' }
			it { should have_link 'Back', href: memos_path }
		end

		# describe "when clicking on 'Edit'" do
		# 	before { click_link 'Edit'}

		# 	it { should have_title 'Edit memo' }
		# 	it { should have_link 'Back', href: memos_path }
		# end
	end

	describe "create new memo" do
		before { visit new_memo_path }

		it { should have_title 'New memo' }
		it { should have_headings 'Memo', 'Create' }
		it { should have_selector 'input' }
		it { should have_selector 'textarea' }
		it { should have_button 'Save' }
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
				fill_in "memo_name", 			with: "A3"
				fill_in "memo_word_list", with: "ABC adl\r\næøå"
				fill_in "memo_hints", 		with: "hintsæøå\r\n"
			end

			it "should create a memo" do
				expect { click_button submit }.to change(Memo, :count).by(1)
			end

			describe "after creating the memo" do
        before { click_button submit }

        it { should have_title 'Memos' }
        it { should have_success_message 'Created a new memo:' }

        describe "when going to the edit memo page" do
				before { click_link 'Edit' }
				
				it { should have_content "ABC\r\nADL\r\nÆØÅ" }
				it { should have_content "HINTSÆØÅ" }
				end
      end
		end
	end

	describe "update memo" do
		let(:memo) { FactoryGirl.create(:memo) }
		before { visit edit_memo_path memo }

		it { should have_title 'Edit memo' }
		it { should have_headings 'Memo', 'Edit' }
		#it { should have_content("93") }
		it { should have_content(memo.word_list) }
		it { should have_content(memo.hints) }
		it { should have_button 'Save' }
		it { should have_link 'Back', href: memos_path }

		let(:submit) { "Save" }

		describe "with blank name" do
			before do
				fill_in "memo_name", with: ""
				click_button submit
			end
			
			it { should have_error_message 'The form contains' }
		end

		describe "with blank word list" do
			before do
				fill_in "memo_word_list" , with: ""
				click_button submit
			end
			
			it { should have_error_message 'The form contains' }
		end

		describe "with valid information" do
			before do
				fill_in "memo_name", 			with: "A3"
				fill_in "memo_word_list", with: "ABC adl\r\næøå"
				fill_in "memo_hints", 		with: "hintsæøå\r\n"
			end

			it "should not create a new memo" do
				expect { click_button submit }.not_to change(Memo, :count)
			end

			# describe "after updating" do
   #      before { click_button submit }

   #      it { should have_title 'Memos' }
   #      it { should have_success_message 'Updated memo:' }
   #    end

			# describe "after creating the memo" do
   #      before { click_button submit }

   #      it { should have_title 'Memos' }
   #      it { should have_success_message 'Created a new memo:' }

   #      describe "when going to the edit memo page" do
			# 	before { click_link 'Edit' }
				
			# 	it { should have_content "ABC\r\nADL\r\nÆØÅ" }
			# 	it { should have_content "HINTSÆØÅ" }
			# 	end
   #    end
		end
	end
end
