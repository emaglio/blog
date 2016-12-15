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
    new_post!

    page.must_have_link "Title"
    page.must_have_link "Subtitle"
    page.must_have_content "Author" 
    page.must_have_content "Title has been created" #flash message
    # why created_at is set on another time?    
    page.must_have_content (DateTime.now).strftime("%d %A, %Y").to_s

    #create post with User as author
    log_in_as_user

    visit "posts/new"

    new_post!("User Title", "User Subtitle", "User Body", "", true)

    page.must_have_link "User Title"
    page.must_have_link "User Subtitle"
    page.must_have_link "UserFirstname" #as set in the test_helper
    page.must_have_content "User Title has been created" #flash message
    page.must_have_content (DateTime.now).strftime("%d %A, %Y").to_s
    
    Post.all.size.must_equal 2
  end

  it "edit (only owner and admin)" do
    visit "posts/new"

    #create post without User as author
    new_post!

    #create post with User as author
    log_in_as_user("edit_user@email.com", "password")
    click_link "New Post"
    new_post!("User Title", "User Subtitle", "User Body", "", true)
    Post.all.size.must_equal 2
    not_user_post = Post.first
    user_post = Post.last

    #can't edit not user post
    page.must_have_link "Title"

    click_link "Title"

    page.wont_have_link "Edit"
    page.wont_have_link "Delete"
    page.must_have_link "Back"

    visit "/posts/#{not_user_post.id}/edit"
    page.current_path.must_equal "/posts"
    page.must_have_content "You are not authorized mate!" #flash message
    
    #edit user_post
    page.must_have_link "User Title"

    click_link "User Title"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"

    click_link "Edit"

    page.must_have_css "#title"
    page.must_have_css "#subtitle"
    page.must_have_css "#body"
    page.must_have_button "Save"
    page.current_path.must_equal "/posts/#{user_post.id}/edit"

    within("//form[@id='edit_post']") do
      fill_in 'Title', with: "New User Title"
      fill_in 'Subtitle', with: "New User Subtitle"
    end
    click_button "Save"

    page.must_have_content "New User Title has been saved" #flash message
    page.current_path.must_equal "/posts/#{user_post.id}"
    page.must_have_content "New User Title"
    page.must_have_content "New User Subtitle"

    #admin edit user_post
    click_link "Sign Out"

    log_in_as_admin
    visit "/posts"

    page.must_have_content "Hi, Admin"
    page.must_have_link "New User Title"

    click_link "New User Title"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"
    page.current_path.must_equal "/posts/#{user_post.id}"

    click_link "Edit"
    page.current_path.must_equal "/posts/#{user_post.id}/edit"

    within("//form[@id='edit_post']") do
      fill_in 'Title', with: "Admin Title"
      fill_in 'Subtitle', with: "Admin Subtitle"
    end
    click_button "Save"

    page.must_have_content "Admin Title"
    page.must_have_content "Admin Subtitle"
    page.must_have_content "by UserFirstname"
    page.must_have_content "Admin Title has been saved" #flash message
  end

  it "delete (only owner and admin)" do 
    visit "posts/new"

    #create post without User as author
    new_post!

    #create post with User as author
    log_in_as_user("edit_user@email.com", "password")
    click_link "New Post"
    new_post!("User Title", "User Subtitle", "User Body", "", true)
    Post.all.size.must_equal 2
    not_user_post = Post.first
    user_post = Post.last

    #random user can't delete a post
    page.must_have_link "Title"

    click_link "Title"

    page.wont_have_link "Edit"
    page.wont_have_link "Delete"
    page.must_have_link "Back"

    click_link "Back"

    #edit user_post
    page.must_have_link "User Title"

    click_link "User Title"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"

    click_link "Delete"

    page.must_have_content "Post deleted" #flash message

    Post.all.size.must_equal 1
    page.must_have_link "Title"
    page.wont_have_link "User Title"

    #admin edit user_post
    click_link "Sign Out"

    log_in_as_admin
    visit "/posts"

    click_link "Title"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"

    click_link "Delete"

    page.must_have_content "Post deleted" #flash message

    Post.all.size.must_equal 0
    page.wont_have_link "Title"
    page.wont_have_link "User Title"
  end

  it "search post" do
    visit "posts/new"
    new_post!("Post 1 search") 

    visit "posts/new"
    new_post!("Post 2 search")

    page.must_have_css "#keynote"
    page.must_have_button "Search" 
    page.must_have_link "Post 1 search"
    page.must_have_link "Post 2 search"

    #searching nil return all posts
    within("//form[@id='search']") do
      fill_in :keynote, with: ""
    end
    click_button "Search"
    page.must_have_link "Post 1 search"
    page.must_have_link "Post 2 search"

    #test only Post 1 is shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "1"
    end
    click_button "Search"
    page.must_have_link "Post 1 search"
    page.wont_have_link "Post 2 search"

    #test only Post 2 is shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "2"
    end
    click_button "Search"
    page.wont_have_link "Post 1 search"
    page.must_have_link "Post 2 search"

    #both posts are shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "search"
    end
    click_button "Search"
    page.must_have_link "Post 1 search"
    page.must_have_link "Post 2 search"

    #none shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "not found"
    end
    click_button "Search"
    page.wont_have_link "Post 1 search"
    page.wont_have_link "Post 2 search"
    page.must_have_content "No posts"
  end
end