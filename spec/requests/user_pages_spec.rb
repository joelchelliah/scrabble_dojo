require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

		it { should have_selector 'h1', text: 'Account' }
		it { should have_selector 'h2', text: 'Profile' }
		it { should have_content(user.name) }
	end

  describe "signup page" do
    before { visit signup_path }

	  it { should have_title 'Scrabble Dojo' }
		it { should have_selector 'h1', text: 'Account' }
		it { should have_selector 'h2', text: 'Sign up' }
    
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "user_name",                  with: "Example User"
        fill_in "user_email",                 with: "user@example.com"
        fill_in "Password",                   with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_selector('div.alert.alert-success', text: 'Welcome to Scrabble Dojo!') }
      end
    end
  end
end