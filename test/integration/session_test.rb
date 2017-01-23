require 'test_helper'

class SessionsIntegrationTest < Trailblazer::Test::Integration
  
  it "invalid log in (not existing)" do
    visit "sessions/new"

    submit!("","")

    # page.must_have_content "must be filled"
    page.must_have_css "#email"
    page.must_have_css "#password"
    page.must_have_button "Sign In"

    submit!("wrong@email.com", "wrong")

    # page.must_have_content "User not found"
    page.must_have_css "#email"
    page.must_have_css "#password"
    page.must_have_button "Sign In"
    page.current_path.must_equal sessions_path
  end

  it "successfully log in" do
    user = User::Create.(email: "test@email.com", password: "password", confirm_password: "password", firstname: "NewUser")["model"]
    
    visit "sessions/new"

    submit!("#{user.email}", "password")

    page.must_have_content "Hi, NewUser"
    page.must_have_link "Sign Out"
    page.wont_have_css "#email"
    page.wont_have_css "#password"
    page.wont_have_button "Sign In"
    page.current_path.must_equal posts_path

    page.must_have_content "Hey mate, welcome back!"
  end

  it "succesfully log out" do
    user = User::Create.(email: "test@email.com", password: "password", confirm_password: "password", firstname: "NewUser")["model"]
    
    visit "sessions/new"

    submit!("#{user.email}", "password")

    page.must_have_content "Hi, NewUser"
    page.must_have_link "Sign Out"

    click_link "Sign Out"
    page.wont_have_content "Hi, NewUser"
    page.must_have_content "See ya!"
  end
end