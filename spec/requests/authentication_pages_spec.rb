require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "log in" do
    before { visit login_path }

    it { should be_the_login_page }

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
      before { log_in user }

      it { should have_title 'Home' }
      it { should have_link('Edit profile', href: edit_user_path(user)) }
      it { should have_link('Log out',      href: logout_path) }
      it { should have_link('Memo',         href: memos_path) }

      it { should_not have_link('Log in',   href: login_path) }
      it { should_not have_link('Browse users',    href: users_path) }

      describe "followed by signout" do
        before { click_link "Log out" }
        it { should have_link('Log in') }
      end
    end
  end

  describe "with valid admin information" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { log_in admin }

    it { should have_title 'Home' }
    it { should have_link('Edit profile', href: edit_user_path(admin)) }
    it { should have_link('Log out',      href: logout_path) }
    it { should have_link('Browse users',        href: users_path) }
    it { should have_link('Memo',        href: memos_path) }

    it { should_not have_link('Log in',   href: login_path) }
    
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path user
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        describe "and then after logging in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Profile')
          end

          describe "and then when logging in again" do
            before do
              delete logout_path
              log_in user
            end

            it "should render the Home page" do
              expect(page).to have_title 'Home'
              expect(page).to have_headings 'Scrabble Dojo', 'Practice makes perfect'
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path user }
          it { should have_title 'Log in' }
          it { should have_notice_message 'Log in to access this page'}
        end

        describe "submitting to the update action" do
          before { patch user_path user }
          specify { expect(response).to redirect_to login_path }
        end
      end

      describe "in the Memos controller" do

        describe "submitting to the create action" do
          before { post memos_path }
          specify { expect(response).to redirect_to(login_path) }
        end

        describe "submitting to the destroy action" do
          before { delete memo_path(FactoryGirl.create(:memo)) }
          specify { expect(response).to redirect_to(login_path) }
        end
      end
    end
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }

    describe "visiting the sign up page after loggin in" do
      before do
        log_in user
        visit signup_path
      end

      it { should have_title('Home') }
      it { should have_notice_message 'You already have an account'}
    end

    describe "submitting a POST request to the Users#create action after logging in" do
      before do
        log_in user, no_capybara: true
        post users_path, user: user
      end
      
      specify { expect(response).to redirect_to root_url }
    end
    

    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { log_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path wrong_user }
        specify { expect(response.body).not_to match 'Profile' }
        specify { expect(response).to redirect_to root_url }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path wrong_user }
        specify { expect(response).to redirect_to root_url }
      end
    end

    describe "as non-admin user" do
      let(:non_admin) { FactoryGirl.create(:user) }
      before { log_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path user }
        specify { expect(response).to redirect_to root_url }
      end
    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { log_in admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path admin }
        specify { expect(response).to redirect_to root_url }
      end
    end
  end
end