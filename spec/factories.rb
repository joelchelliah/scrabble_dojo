FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@scrabble.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :memo do
    sequence(:name)  { |n| "Memo #{n}" }
    word_list    	"ABC\nADL\nAGA\nAGE\nAGG"
    hints 				"some hints"
    num_practices	0
  end
end