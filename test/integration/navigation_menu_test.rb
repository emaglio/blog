require 'test_helper'

class NavigationMenuTest < Trailblazer::Test::Integration

  it "basic" do
    #no user logged in
    visit 'posts'

    find('.nav').must_have_link "Home"
    find('.nav').must_have_link "New User"
    find('.nav').must_have_link "New Post"
    find('.nav').must_have_link "Sign In"
    find('.nav').wont_have_link "My Posts"

    #normal user logged in
    log_in_as_user

    find('.nav').must_have_link "Hi, UserFirstname"
    find('.nav').must_have_link "Home"
    find('.nav').wont_have_link "New User"
    find('.nav').must_have_link "New Post"
    find('.nav').wont_have_link "Sign In"
    find('.nav').wont_have_link "All Users"
    find('.nav').must_have_link "My Posts"
    find('.nav').must_have_link "Sign Out"

    click_link "Sign Out"

    #logged in as admin
    log_in_as_admin

    find('.nav').must_have_link "Hi, Admin"
    find('.nav').must_have_link "Home"
    find('.nav').wont_have_link "New User"
    find('.nav').must_have_link "New Post"
    find('.nav').wont_have_link "Sign In"
    find('.nav').must_have_link "All Users"
    find('.nav').must_have_link "All Posts"
    find('.nav').must_have_link "My Posts"
    find('.nav').must_have_link "Sign Out"
  end

end