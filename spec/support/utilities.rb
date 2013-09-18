include ApplicationHelper

def valid_login(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

def valid_signup()
  fill_in "user_name",                  with: "Example User"
  fill_in "user_email",                 with: "user@example.com"
  fill_in "Password",                   with: "foobar"
  fill_in "user_password_confirmation", with: "foobar"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_headings do |h1_message, h2_message|
  match do |page|
    expect(page).to have_selector('h1', text: h1_message)
    expect(page).to have_selector('h2', text: h2_message)
  end
end