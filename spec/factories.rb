FactoryGirl.define do
  factory :user do
    name     "Joel Chelliah"
    email    "jc@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :memo do
    name     			"A3"
    word_list    	"ABC\nADL\nAGA\nAGE\nAGG"
    hints 				"some hints"
    health_decay 	10.days.ago
    num_practices	3
  end
end