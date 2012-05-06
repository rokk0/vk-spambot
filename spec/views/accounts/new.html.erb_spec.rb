require 'spec_helper'

describe "accounts/new" do
  before(:each) do
    assign(:account, stub_model(Account,
      :user_id => 1,
      :email => "MyString",
      :password => "MyString",
      :code => 1,
      :approved => false
    ).as_new_record)
  end

  it "renders new account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => accounts_path, :method => "post" do
      assert_select "input#account_user_id", :name => "account[user_id]"
      assert_select "input#account_email", :name => "account[email]"
      assert_select "input#account_password", :name => "account[password]"
      assert_select "input#account_code", :name => "account[code]"
      assert_select "input#account_approved", :name => "account[approved]"
    end
  end
end
