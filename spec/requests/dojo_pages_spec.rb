require 'spec_helper'

describe "Dojo" do
	subject { page }

	describe "Home page" do
		before { visit root_url }

		it { should have_title 'Home' }
		it { should have_headings 'Scrabble Dojo', 'Practice makes perfect' }
		#it { should have_selector 'p', text: 'Random bingo:' }
		#it { should have_link 'Next', href: root_url }
	end
end