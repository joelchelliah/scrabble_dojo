require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

    it { should have_title 'Profile' }
		it { should have_headings 'Account', 'Profile' }
    it { should have_content(user.name) }
		it { should have_content(user.email) }
	end

  describe "signup page" do
    before { visit signup_path }

	  it { should have_title 'Sign up' }
		it { should have_headings 'Account', 'Sign up' }
    
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_error_message 'The form contains' }
      end
    end

    describe "with valid information" do
      before { valid_signup }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_title 'Home' }
        it { should have_link 'Log out' }
        it { should have_success_message 'Welcome to Scrabble Dojo!' }
      end
    end
  end
end