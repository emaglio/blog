require 'test_helper'

class UsersIntegrationTest < Trailblazer::Test::Integration

  it "create" do 
    visit "posts/new"

    page.must_have_css "#title"
    page.must_have_css "#subtitle"
    page.must_have_css "#body"
    page.must_have_css "#author"
    page.must_have_button "Create Post"

    #new_post!(title, subtitle, body, author, user_signed_in?)
    new_post!("", "", "", "", false)

    page.must_have_content "must be filled"

    #create post without User as author
    new_post!()

    page.must_have_link "Title"
    page.must_have_link "Subtitle"
    page.must_have_content "Author" 
    page.must_have_content (DateTime.now).strftime("%d %A, %Y").to_s

    #create post with User as author
    log_in_as_user

    visit "posts/new"

    new_post!("User Title", "User Subtitle", "User Body", "", true)

    page.must_have_link "User Title"
    page.must_have_link "User Subtitle"
    page.must_have_link "UserFirstname" #as set in the test_helper
    page.must_have_content (DateTime.now).strftime("%d %A, %Y").to_s
    
  end
end