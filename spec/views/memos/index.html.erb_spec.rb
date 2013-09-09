require 'spec_helper'

describe "memos/index" do
  before(:each) do
    assign(:memos, [
      stub_model(Memo,
        :name => "Name",
        :hints => "MyText",
        :word_list => "MyText",
        :updated_at => Time.now()
      ),
      stub_model(Memo,
        :name => "Name",
        :hints => "MyText",
        :word_list => "MyText",
        :updated_at => Time.now()
      )
    ])
  end

  it "renders a list of memos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
