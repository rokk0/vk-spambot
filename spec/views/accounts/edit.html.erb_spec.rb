require 'spec_helper'

describe "accounts/edit" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :user_id => 1,
      :email => "MyString",
      :password => "MyString",
      :code => 1,
      :approved => false
    ))
  end

  it "renders the edit account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => accounts_path(@account), :method => "post" do
      assert_select "input#account_user_id", :name => "account[user_id]"
      assert_select "input#account_email", :name => "account[email]"
      assert_select "input#account_password", :name => "account[password]"
      assert_select "input#account_code", :name => "account[code]"
      assert_select "input#account_approved", :name => "account[approved]"
    end
  end
end
