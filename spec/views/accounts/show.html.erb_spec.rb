require 'spec_helper'

describe "accounts/show" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :user_id => 1,
      :email => "Email",
      :password => "Password",
      :code => 2,
      :approved => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Email/)
    rendered.should match(/Password/)
    rendered.should match(/2/)
    rendered.should match(/false/)
  end
end
