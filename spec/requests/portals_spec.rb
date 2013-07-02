require 'spec_helper'

describe "Portals" do
  before :all do
    @user = FactoryGirl.create(:user_with_email, :password=>"password")
    @hcp_user = FactoryGirl.create(:hcp_user, :password=>"password")

  end

  xit "goes to login page when user attempts to access portal" do
    visit root_path
    click_link "Messages"
    current_path.should == login_path
    page.should have_content("First log in")
  end

  xit "should let user log into portal" do
    visit login_path
    fill_in "Email", :with => @user.email
    fill_in "Password",  :with => 'password'
    click_button "Log in"
    page.should have_content("Logged in")
  end

  xit "should not let patients log into portal" do
    visit root_path
    click_link "Messages"
    fill_in "Email", :with => @user.email
    fill_in "Password",  :with => 'password'
    click_button "Log in"
    page.should have_content("Access Denied")
  end

  xit "should let HCP log into the portal" do
    visit root_path
    click_link "Messages"
    fill_in "Email", :with => @hcp_user.email
    fill_in "Password",  :with => 'password'
    click_button "Log in"
    current_path.should == messages_index_path
  end

end
