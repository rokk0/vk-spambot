require 'spec_helper'

describe "bots/edit" do
  before(:each) do
    @bot = assign(:bot, stub_model(Bot,
      :user_id => "",
      :email => "",
      :password => "",
      :bot_type => "",
      :page => "",
      :page_hash => "",
      :message => "",
      :count => "",
      :interval => "MyString"
    ))
  end

  it "renders the edit bot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bots_path(@bot), :method => "post" do
      assert_select "input#bot_user_id", :name => "bot[user_id]"
      assert_select "input#bot_email", :name => "bot[email]"
      assert_select "input#bot_password", :name => "bot[password]"
      assert_select "input#bot_bot_type", :name => "bot[bot_type]"
      assert_select "input#bot_page", :name => "bot[page]"
      assert_select "input#bot_page_hash", :name => "bot[page_hash]"
      assert_select "input#bot_message", :name => "bot[message]"
      assert_select "input#bot_count", :name => "bot[count]"
      assert_select "input#bot_interval", :name => "bot[interval]"
    end
  end
end
