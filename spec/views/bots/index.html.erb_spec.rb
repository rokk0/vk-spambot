require 'spec_helper'

describe "bots/index" do
  before(:each) do
    assign(:bots, [
      stub_model(Bot,
        :user_id => "",
        :email => "",
        :password => "",
        :bot_type => "",
        :page => "",
        :page_hash => "",
        :message => "",
        :count => "",
        :interval => "Interval"
      ),
      stub_model(Bot,
        :user_id => "",
        :email => "",
        :password => "",
        :bot_type => "",
        :page => "",
        :page_hash => "",
        :message => "",
        :count => "",
        :interval => "Interval"
      )
    ])
  end

  it "renders a list of bots" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Interval".to_s, :count => 2
  end
end
