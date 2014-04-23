def word_search(word)
  fill_in "word", with: word
  click_button "Search"
end

def stem_search(word, option=nil)
  fill_in "word", with: word
  select option, from: "option" unless option.blank?
  click_button "Search"
end


RSpec::Matchers.define :have_these_short_words do | words |
  match do |page|
    words.each do |word|
      expect(page).to have_selector 'h3', text: word[0]
      expect(page).to have_content word
    end
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


RSpec::Matchers.define :be_the_short_words_page_for do | x_letter_words |
  match do |page|
    expect(page).to have_title 'Short words'
    expect(page).to have_headings "Words", "#{x_letter_words}"
    expect(page).to have_short_words_buttons
  end
end

RSpec::Matchers.define :be_the_word_search_page do
  match do |page|
    expect(page).to have_title 'Word search'
    expect(page).to have_selector 'h1', text: 'Words'
    expect(page).to have_selector 'h2', text: 'Search'
    expect(page).to have_selector 'input'
    expect(page).to have_button 'Search'
  end
end

RSpec::Matchers.define :be_the_word_stems_page do
  match do |page|
    expect(page).to have_title 'Word stems'
    expect(page).to have_selector 'h1', text: 'Words'
    expect(page).to have_selector 'h2', text: 'Stems'
    expect(page).to have_selector 'input'
    expect(page).to have_selector 'select'
    expect(page).to have_button 'Search'
  end
end

RSpec::Matchers.define :be_the_manage_words_page do
  match do |page|
    expect(page).to have_title 'Manage words'
    expect(page).to have_selector 'h1', text: 'Words'
    expect(page).to have_selector 'h2', text: 'Manage'
    expect(page).to have_selector 'input'
  end
end

RSpec::Matchers.define :be_the_add_word_page_for do | word |
  match do |page|
    expect(page).to have_title "Add #{word}"
    expect(page).to have_headings 'Words', "Add #{word}?"
    expect(page).to have_button 'Add'
    expect(page).to have_link 'Cancel'
  end
end

RSpec::Matchers.define :be_the_remove_word_page_for do | word |
  match do |page|
    expect(page).to have_title "Remove #{word}"
    expect(page).to have_content "The word #{word} was found. Do you want to remove it?"
    expect(page).to have_headings 'Words', "Remove #{word}?"
    expect(page).to have_link 'Remove'
    expect(page).to have_link 'Cancel'
  end
end