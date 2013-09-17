FactoryGirl.define do
  factory :user do
    name     "Joel Chelliah"
    email    "jc@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end
end