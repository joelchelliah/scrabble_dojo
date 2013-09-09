require 'spec_helper'

describe "memos/edit" do
  before(:each) do
    @memo = assign(:memo, stub_model(Memo,
      :name => "MyString",
      :hints => "MyText",
      :word_list => "MyText"
    ))
  end

  it "renders the edit memo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", memo_path(@memo), "post" do
      assert_select "input#memo_name[name=?]", "memo[name]"
      assert_select "textarea#memo_hints[name=?]", "memo[hints]"
      assert_select "textarea#memo_word_list[name=?]", "memo[word_list]"
    end
  end
end
