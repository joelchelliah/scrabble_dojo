require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    describe "as a regular user" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        log_in user
        visit users_path
      end

      it { should have_title('Home') }
      it { should_not have_headings 'User', 'Overview' }
    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before(:each) do
        log_in admin
        visit users_path
      end

      it { should have_title('Users') }
      it { should have_headings 'User', 'Overview' }

      describe "pagination" do
        before(:all) { 30.times { FactoryGirl.create(:user) } }
        after(:all)  { User.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each user" do
          User.paginate(page: 1).each do |user|
            expect(page).to have_selector('li', text: user.name)
          end
        end
      
        describe "delete links" do
          it { should_not have_link('delete', href: user_path(admin)) }
          it { should have_link('delete', href: user_path(User.first)) }
          it "should be able to delete another user" do
            expect do
              click_link('delete', match: :first)
            end.to change(User, :count).by(-1)
          end
          it { should_not have_link('delete', href: user_path(admin)) }
        end
      end
    end
  end

  describe "show" do
    describe "as a regular user" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        log_in user
        visit user_path(user)
      end

      it { should have_title('Home') }
      it { should_not have_headings 'User', 'Profile' }
    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      let!(:m1) { FactoryGirl.create(:memo, user: admin, name: "A2") }
      let!(:m2) { FactoryGirl.create(:memo, user: admin, name: "A3") }
      before(:each) do
        log_in admin
        visit user_path(admin)
      end

      it { should have_title('Profile') }
      it { should have_headings 'User', 'Profile' }

      describe "list of user's memos" do
        it { should have_content(m1.name) }
        it { should have_content(m2.name) }
        it { should have_content(admin.memos.count) }
      end
    end
  end


  describe "signup" do
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
        it { should have_link 'Log out', href: logout_path }
        it { should have_success_message 'Welcome to Scrabble Dojo!' }
      end
    end
  end

  describe "edit profile" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user
      visit edit_user_path(user)
    end

    it { should have_title 'Profile' }
    it { should have_headings 'Account', 'Edit profile' }

    let(:submit) { "Update my account" }

    describe "with invalid information" do
      before { click_button submit }

      it { should have_error_message 'The form contains' }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",                       with: new_name
        fill_in "user_email",                 with: new_email
        fill_in "user_password",              with: user.password
        fill_in "user_password_confirmation", with: user.password
        click_button "Update my account"
      end

      it { should have_title 'Home' }
      it { should have_link 'Log out', href: logout_path }
      it { should have_success_message 'Profile updated' }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        log_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end