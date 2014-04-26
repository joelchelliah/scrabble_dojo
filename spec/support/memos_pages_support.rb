def fill_out_memo_fields(name, words, hints)
  fill_in "memo_name" , with: name
  fill_in "memo_word_list", with: words
  fill_in "memo_hints",     with: hints
end


RSpec::Matchers.define :have_memos_overview_buttons do
  match do |page|
    expect(page).to have_link 'New memo', href: new_memo_path
    expect(page).to have_link 'Sort by name', href: memos_path
    expect(page).to have_link 'Sort by health', href: by_health_memos_path
    expect(page).to have_link 'Sort by word count', href: by_word_count_memos_path
    expect(page).to have_link 'Revise weakest memo', href: revise_weakest_memos_path
  end
end

RSpec::Matchers.define :have_memos_edit_fields do
  match do |page|
    expect(page).to have_selector 'input'
    expect(page).to have_selector 'textarea', 'memo[hints]'
    expect(page).to have_selector 'textarea', 'memo[word_list]'
    expect(page).to have_link 'Advanced options'
    expect(page).to have_link 'Back', href: memos_path
  end
end

RSpec::Matchers.define :show_advanced_options do
  match do |page|
    expect(page).to have_link 'Advanced options', visible: false
    expect(page).to have_selector 'label', text: "Accepted words", visible: true
    expect(page).to have_selector 'label', text: "Disable practice mode", visible: true
  end
end

RSpec::Matchers.define :hide_advanced_options do
  match do |page|
    expect(page).to have_link 'Advanced options', visible: true
    expect(page).to have_selector 'label', text: "Accepted words", visible: false
    expect(page).to have_selector 'label', text: "Disable practice mode", visible: false
  end
end


RSpec::Matchers.define :be_the_memos_overview_page do
  match do |page|
    expect(page).to have_title 'Memos'
    expect(page).to have_headings 'Memos', 'Overview'
  end
end

RSpec::Matchers.define :be_the_create_memo_page do
  match do |page|
    expect(page).to have_title 'Create memo'
    expect(page).to have_headings 'Memos', 'Create'
    expect(page).to have_button 'Create'
    expect(page).to have_memos_edit_fields
  end
end

RSpec::Matchers.define :be_the_update_memo_page_for do |memo|
  match do |page|
    expect(page).to have_title "Update #{memo.name}"
    expect(page).to have_headings 'Memos', "Update #{memo.name}"
    expect(page).to have_button 'Update'
    expect(page).to have_memos_edit_fields
  end
end

RSpec::Matchers.define :be_the_revise_memo_page_for do |memo|
  match do |page|
    expect(page).to have_title "Revise #{memo.name}"
    expect(page).to have_headings 'Memos', "Revise #{memo.name}"
    expect(page).to have_link 'Back', href: memos_path
    expect(page).to have_link 'Show hints'
    expect(page).to have_link 'Hide words'
    expect(page).to have_link 'Practice'
    expect(page).to have_content 'Health:'
    expect(page).to have_content 'Word count:'
    expect(page).to have_content 'Practice count:'
    expect(page).to have_content 'Best time:'
  end
end

RSpec::Matchers.define :be_the_memo_results_page_for do |memo|
  match do |page|
    expect(page).to have_title "Results #{memo.name}"
    expect(page).to have_headings 'Memos', "Results #{memo.name}"
    expect(page).to have_link 'Overview'
    expect(page).to have_link 'Revise again'
    expect(page).to have_content 'Session completed in'
  end
end