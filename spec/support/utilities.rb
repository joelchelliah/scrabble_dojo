include ApplicationHelper

def valid_signup()
  fill_in "user_name",                  with: "Example User"
  fill_in "user_email",                 with: "user@example.com"
  fill_in "Password",                   with: "foobar"
  fill_in "user_password_confirmation", with: "foobar"
end

def log_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit login_path
    valid_login user
  end
end

def valid_login(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-notice', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_flash_message_of_type do |type|
  match do |page|
    expect(page).to have_selector("div.alert.alert-#{type}")
  end
end

RSpec::Matchers.define :go_to_the_login_page do
  match do |page|
    expect(page).to have_title 'Log in'
    expect(page).to have_selector('h1', text: 'Account')
    expect(page).to have_selector('h2', text: 'Log in')
  end
end

RSpec::Matchers.define :go_to_the_home_page do
  match do |page|
    expect(page).to have_title 'Home'
    expect(page).to have_selector('h1', text: 'Scrabble Dojo')
    expect(page).to have_selector('h2', text: 'Practice makes perfect!')
    expect(page).to have_content 'Welcome'
  end
end

RSpec::Matchers.define :have_headings do |h1_message, h2_message|
  match do |page|
    expect(page).to have_selector('h1', text: h1_message)
    expect(page).to have_selector('h2', text: h2_message)
  end
end

RSpec::Matchers.define :have_short_words_buttons do
  match do |page|
    expect(page).to have_link "Two letters"
    expect(page).to have_link "Three letters"
    expect(page).to have_link "Four letters"
    expect(page).to have_link "Words with C"
    expect(page).to have_link "Words with W"
  end
end