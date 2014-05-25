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
    word_list     "ABC\nADL\nAGA\nAGE\nAGG"
    hints         "some hints"
    num_practices 0
    practice_disabled false
    user
  end

  factory :word_entry do
    sequence(:word)  { |n| "Word#{n}" }
    letters         "abcd"
    length          5
    first_letter    "a"
  end

  factory :bingo_challenge do
    sequence(:min_range) { |n| n * 10 }
    sequence(:max_range) { |n| (n + 1) * 10 }
    mode "ordered"
    level "1"
    tiles_list "ABC DEF GHI"
    user
  end
end