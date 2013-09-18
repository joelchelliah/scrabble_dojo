require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_title 'Log in' }
    it { should have_headings 'Account', 'Log in' }

		describe "with invalid information" do
      before { click_button "Log in" }

      it { should have_title 'Log in' }
      it { should have_error_message 'Invalid' }

      describe "after visiting another page" do
			  before { click_link "Home" }
        it { should have_title 'Home' }
			  it { should_not have_error_message '' }
			end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_login(user) }

      it { should have_title 'Home' }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Log out',    href: logout_path) }
      it { should_not have_link('Log in', href: login_path) }

      describe "followed by signout" do
        before { click_link "Log out" }
        it { should have_link('Log in') }
      end
    end
  end
end