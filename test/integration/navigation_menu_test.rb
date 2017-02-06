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
    find('.nav').must_have_link "Approved (0)"
    find('.nav').must_have_link "Pending (0)"
    find('.nav').must_have_link "Declined (0)"
    find('.nav').must_have_link "My Posts"
    find('.nav').must_have_link "Sign Out"
  end

  it "All Posts and My Posts menu" do
    log_in_as_user
    visit "posts/new"
    new_post!("Post1", "Subtitle1", "Body1", "", true)
    post1 = Post.last

    visit "posts/new"
    new_post!("Post2", "Subtitle2", "Body2", "", true)
    post2 = Post.last

    approve_post!(post1.id)
    decline_post!(post2.id) 

    visit "posts/new"
    new_post!("Post3")
    
    log_in_as_admin

    find('.nav').must_have_link "All Posts"
    find('.nav').must_have_link "Approved (1)"
    find('.nav').must_have_link "Pending (1)"
    find('.nav').must_have_link "Declined (1)"

    find('.nav').click_link "Approved (1)"
    page.must_have_content "Here are the approved posts:"
    find('.main').must_have_content "Post1"
    find('.main').wont_have_link "Post2"
    find('.main').wont_have_link "Post3"

    find('.nav').click_link "Declined (1)"
    page.must_have_content "Here are the declined posts:"
    find('.main').must_have_link "Post2"
    find('.main').wont_have_link "Post1"
    find('.main').wont_have_link "Post3"

    find('.nav').click_link "Pending (1)"
    page.must_have_content "Here are the pending posts:"
    find('.main').must_have_link "Post3"
    find('.main').wont_have_link "Post1"
    find('.main').wont_have_link "Post2"

    click_link "Sign Out"

    log_in_as_user

    find('.nav').click_link "My Posts"
    find('.main').must_have_css ".fa.fa-check-circle-o"
    find('.main').must_have_link "Post2"
    find('.main').must_have_css ".fa.fa-times"
    find('.main').must_have_link "Post1"
    find('.main').wont_have_link "Post3"
  end
end