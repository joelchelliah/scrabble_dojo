require 'spec_helper'

describe "Dojo" do
	subject { page }

	describe "Home page" do
		before { visit home_path }

		it { should have_title 'Scrabble Dojo' }
		it { should have_selector 'h1', text: 'Scrabble Dojo' }
		it { should have_selector 'h2', text: 'Practice makes perfect!' }
		it { should have_selector 'p', text: 'Tilfeldig bingo:' }
		it { should have_link 'Neste', href: home_path }
	end
end