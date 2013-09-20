require 'spec_helper'

describe "Memos" do
	subject { page }

	describe "memo overview" do
		before(:all) { 3.times { FactoryGirl.create(:memo) } }
    after(:all)  { Memo.delete_all }

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

		describe "when clicking on one of the Edits" do
			before { first(:link, 'Edit').click }

			it { should have_title 'Edit memo' }
			it { should have_link 'Back', href: memos_path }
		end
	end


	describe "create new memo" do
		before { visit new_memo_path }

		it { should have_title 'New memo' }
		it { should have_headings 'Memo', 'Create' }
		it { should have_selector 'input' }
		it { should have_selector 'textarea' }
		it { should have_button 'Create' }
		it { should have_link 'Back', href: memos_path }

		let(:submit) { "Create" }

		describe "with blank name" do
			it "should not create a memo" do
				expect {click_button submit }.not_to change(Memo, :count)
			end
		end

		describe "with blank word list" do
			before { fill_in "memo_name" , with: "A3" }
			
			it "should not create a memo" do
				expect { click_button submit }.not_to change(Memo, :count)
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

        describe "and then when going to the edit memo page" do
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
		it { should have_button 'Update' }
		it { should have_link 'Back', href: memos_path }

		let(:submit) { "Update" }

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
				fill_in "memo_word_list", with: "ABC æøå"
				fill_in "memo_hints", 		with: "hintsæøå\r\n"
			end

			it "should not create a new memo" do
				expect { click_button submit }.not_to change(Memo, :count)
			end

			describe "after updating" do
        before { click_button submit }

        it { should have_title 'Memos' }
        it { should have_success_message 'Updated memo:' }

        describe "and then when going back to the edit memo page" do
					before { click_link 'Edit' }
					
					it { should have_content "ABC\nÆØÅ" }
					it { should have_content "HINTSÆØÅ" }
				end
      end
		end
	end


	describe "revise memo" do
		let(:memo) { FactoryGirl.create(:memo) }
		before { visit memo_path memo }

		it { should have_title memo.name }
		it { should have_headings 'Memo', 'Revise' }
		it { should have_link 'Back', href: memos_path }
		it { should have_link 'Show hints' }
		it { should have_link 'Hide words' }
		it { should have_link 'Practice' }

		describe "after starting practice session" do
			before { click_link 'Practice' }

			it { should have_button 'Done' }

			describe "and then after completing practice with wrong information" do
				before do
					fill_in :message, with: "asdf lol haha this is wrong"
					click_button 'Done'
				end

				it { should_not have_flash_message_of_type 'form_practice' }
				it { should_not have_flash_message_of_type 'form_words' }
				it { should_not have_flash_message_of_type 'missed_words' }
				it { should have_content 'Health replenished: 0%' }
				it { should have_content 'You made too many mistakes.' }
				it { should have_link 'Overview' }
				it { should have_link 'Revise again' }
			end

			describe "and then after completing practice with correct information" do
				let(:practice_count) { memo.num_practices }
				before do
					fill_in :message, with: "abc adl AGA age AGG"
					click_button 'Done'
				end

				it { should_not have_flash_message_of_type 'form_practice' }
				it { should_not have_flash_message_of_type 'form_words' }
				it { should_not have_flash_message_of_type 'missed_words' }
				it { should have_content 'Health replenished:' }
				it { should_not have_content 'You made too many mistakes.' }
				it { should have_link 'Overview' }
				it { should have_link 'Revise again' }
				it { should have_content "Practice count: #{practice_count + 1}"}

				describe "and then when going to overview" do
					before { click_link 'Overview' }

					it { should have_title 'Memos' }
					it { should have_headings 'Memo', 'Overview' }
				end

				describe "and then when choosing to revise again" do
					before { click_link 'Revise again' }

					it { should have_title memo.name }
					it { should have_headings 'Memo', 'Revise' }
				end
			end
		end
	end
end
