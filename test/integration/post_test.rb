require 'test_helper'

class UsersIntegrationTest < Trailblazer::Test::Integration

  let (:admin) { admin_for }

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

    #add current user here so the Welcome email is sent and
    #I can test that the email is not sent if the post.user_id is nill
    current_user = admin
    num_email = Mail::TestMailer.deliveries.length
    #create post without User as author
    new_post!
    page.must_have_content "Title has been created and it will publiched if it will be approved by the Administrator. Thank you!" #flash message

    #approve it to test the show
    approve_post!(::Post.last.id)

    page.must_have_link "Title"
    page.must_have_link "Subtitle"
    page.must_have_content "Author"
    #user notification
    Mail::TestMailer.deliveries.length.must_equal num_email
    
    # why created_at is set on another time?    
    # page.must_have_content (DateTime.now).strftime("%d %A, %Y").to_s

    #create post with User as author
    log_in_as_user

    num_email = Mail::TestMailer.deliveries.length
    visit "posts/new"

    new_post!("User Title", "User Subtitle", "User Body", "", true)
    #user notification
    Mail::TestMailer.deliveries.length.must_equal num_email+1
    Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
    Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - User Title has been created"
    
    page.must_have_content "User Title has been created and it will publiched if it will be approved by the Administrator. Thank you!" #flash message

    #approve it to test the show
    approve_post!(::Post.last.id)
    log_in_as_user    

    page.must_have_link "User Title"
    page.must_have_link "User Subtitle"
    page.must_have_link "UserFirstname"
    # page.must_have_content (DateTime.now).strftime("%d %A, %Y").to_s
    #user notification
    Mail::TestMailer.deliveries.length.must_equal num_email+2
    Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
    Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Congratulation User Title has been published"

    Post.all.size.must_equal 2
  end

  it "show" do
    visit "posts/new"

    #create post without User as author
    new_post!

    page.must_have_content "No post"

    #approve it to test the editing
    approve_post!(::Post.last.id)

    page.must_have_content "Title"
    find('.main').click_link "Title"

    page.must_have_content "Title"
    page.must_have_content "Subtitle"
    page.must_have_content "Body"
    page.must_have_content "Author"
    page.wont_have_link "Edit"
    page.wont_have_link "Delete"
    page.must_have_link "Back to posts list"

    visit "sessions/new"

    log_in_as_user

    visit "posts/new"

    new_post!("User Title", "User Subtitle", "User Body", "", true)

    #approve it to test the editing
    approve_post!(::Post.last.id)

    page.must_have_content "User Title"
    click_link "User Title"

    page.must_have_content "User Title"
    page.must_have_content "User Subtitle"
    page.must_have_content "User Body"
    page.must_have_content "UserFirstname"
    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back to posts list"

    click_link "Sign Out"

    log_in_as_admin

    click_link "User Title"

    page.must_have_content "User Title"
    page.must_have_content "User Subtitle"
    page.must_have_content "User Body"
    page.must_have_content "UserFirstname"
    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back to posts list"

    page.must_have_css "#status"
    page.must_have_css "#message"
    page.must_have_button "Update" 
  end

  it "edit (only owner and admin)" do
    visit "posts/new"

    #create post without User as author
    new_post!
    #approve it to test the editing
    approve_post!(::Post.last.id)

    #create post with User as author
    log_in_as_user("edit_user@email.com", "password")
    click_link "New Post"
    new_post!("User Title", "User Subtitle", "User Body", "", true)
    #approve it to test the editing
    approve_post!(::Post.last.id)
    log_in_as_user("edit_user@email.com", "password")

    Post.all.size.must_equal 2
    not_user_post = Post.find_by(title: "Title")
    user_post = Post.find_by(title: "User Title")

    #can't edit not user post
    page.must_have_link "Title"
    page.must_have_link "User Title"

    first('.main').click_link "Title"

    page.wont_have_link "Edit"
    page.wont_have_link "Delete"
    page.must_have_link "Back"

    visit "/posts/#{not_user_post.id}/edit"
    page.current_path.must_equal "/posts"
    page.must_have_content "You are not authorized mate!" #flash message
    
    #edit user_post
    page.must_have_link "User Title"

    first('.main').click_link "User Title"
    
    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"
    page.must_have_content "Posted by Me"

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

    first('.main').click_link "New User Title"

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

    new_post!
    #approve it to test the deleting
    approve_post!(::Post.last.id)

    #create post with User as author
    log_in_as_user("delete_user@email.com", "password")
    click_link "New Post"
    new_post!("User Title", "User Subtitle", "User Body", "", true)
    #approve it to test the deleting
    approve_post!(::Post.last.id)
    log_in_as_user("delete_user@email.com", "password")

    Post.all.size.must_equal 2
    not_user_post = Post.first
    user_post = Post.last

    #random user can't delete a post
    page.must_have_link "Title"

    first('.main').click_link "Title"

    page.wont_have_link "Edit"
    page.wont_have_link "Delete"
    page.must_have_link "Back"

    click_link "Back"

    #edit user_post
    page.must_have_link "User Title"

    first('.main').click_link "User Title"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"

    num_email = Mail::TestMailer.deliveries.length
    click_link "Delete"

    page.must_have_content "Post deleted" #flash message
    #user notification
    Mail::TestMailer.deliveries.length.must_equal num_email+1
    Mail::TestMailer.deliveries.last.to.must_equal ["delete_user@email.com"]
    Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - User Title has been deleted"

    Post.all.size.must_equal 1
    page.must_have_link "Title"
    page.wont_have_link "User Title"

    #admin edit user_post
    click_link "Sign Out"

    log_in_as_admin
    visit "/posts"

    first('.main').click_link "Title"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Back"

    click_link "Delete"

    page.must_have_content "Post deleted" #flash message

    Post.all.size.must_equal 0
    page.wont_have_link "Title"
    page.wont_have_link "User Title"
  end

  it "approve only admin" do
    visit "posts/new"

    new_post!
    post1 = Post.last
    #create post with User as author
    log_in_as_user("user@email.com", "password")
    click_link "New Post"
    new_post!("User Title", "User Subtitle", "User Body", "", true)
    post2 = Post.last


    visit "posts"
    #none of the Posts have been approved
    page.must_have_content "No post"

    log_in_as_admin
    #admin can see all the Posts
    page.must_have_content "Title"
    page.must_have_content "User Title"

    #approve the first post
    visit "/posts/#{post1.id}"
    within("//form[@id='status_form']") do
      select('Approved', :from => 'status')
      click_button "Update"
    end

    page.must_have_content "Post approved!" #flash message

    #decline the second one
    visit "/posts/#{post2.id}"
    within("//form[@id='status_form']") do
      select('Declined', :from => 'status')
      click_button "Update"
    end

    page.must_have_content "Post declined!" #flash message

    click_link "Sign Out"

    log_in_as_user
    visit "posts"

    page.must_have_content "Title"
    page.wont_have_content "User Title"
  end

  it "search post" do
    visit "posts/new"
    new_post!("Post 1 search") 
    #approve to test the searching
    approve_post!(::Post.last.id)

    visit "posts/new"
    new_post!("Post 2 search")
    #approve to test the searching
    approve_post!(::Post.last.id)

    page.must_have_css "#keynote"
    page.must_have_button "Search" 
    page.must_have_link "Post 1 search"
    page.must_have_link "Post 2 search"

    #searching nil return all posts
    within("//form[@id='search']") do
      fill_in :keynote, with: ""
    end
    click_button "Search"
    find('.main').must_have_link "Post 1 search"
    find('.main').must_have_link "Post 2 search"

    #test only Post 1 is shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "1"
    end
    click_button "Search"
    find('.main').must_have_link "Post 1 search"
    find('.main').wont_have_link "Post 2 search"

    #test only Post 2 is shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "2"
    end
    click_button "Search"
    find('.main').wont_have_link "Post 1 search"
    find('.main').must_have_link "Post 2 search"

    #both posts are shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "search"
    end
    click_button "Search"
    find('.main').must_have_link "Post 1 search"
    find('.main').must_have_link "Post 2 search"

    #none shown
    within("//form[@id='search']") do
      fill_in :keynote, with: "not found"
    end
    click_button "Search"
    find('.main').wont_have_link "Post 1 search"
    find('.main').wont_have_link "Post 2 search"
    find('.main').must_have_content "No posts"
  end

  it "advanced search" do #needs to add the "when" option
    visit "posts/new"
    new_post!("Title 1", "Subtitle 1", "Body1", "User1", false)
    #approve to test the searching  
    approve_post!(::Post.last.id)

    visit "posts/new"
    new_post!("Title 2", "Subtitle 1", "Body2", "User1", false)
    #approve to test the searching
    approve_post!(::Post.last.id)

    visit "posts/new"
    new_post!("Title 3", "Subtitle 1", "Body2", "User2", false) 
    #approve to test the searching
    approve_post!(::Post.last.id)

    visit root_path
    page.must_have_link "Advanced" 

    click_link "Advanced"

    page.must_have_css "#title"
    page.must_have_css "#subtitle"
    page.must_have_css "#body"
    page.must_have_css "#author"
    page.must_have_css "#from"
    page.must_have_css "#to"

    #only Title 1 will be shown
    within("//form[@id='advanced_search']") do
      fill_in :title, with: "Title 1"
      fill_in :subtitle, with: "Subtitle 1"
      fill_in :author, with: "User1"
    end
    find('.main').click_button "Search"

    find('.main').must_have_link "Title 1"
    find('.main').must_have_link "Subtitle 1"
    find('.main').must_have_content "by User1"

    click_link "Advanced"
    #none
    within("//form[@id='advanced_search']") do
      fill_in :title, with: "Title 1"
      fill_in :subtitle, with: "Subtitle 1"
      fill_in :author, with: "User2"
    end
    find('.main').click_button "Search"

    find('.main').wont_have_link "Title 1"
    find('.main').wont_have_link "Subtitle 1"
    find('.main').wont_have_content "by User1"
    find('.main').must_have_content "No posts"

    click_link "Advanced"
    #all
    within("//form[@id='advanced_search']") do
      fill_in :subtitle, with: "Subtitle 1"
    end
    find('.main').click_button "Search"

    find('.main').must_have_link "Title 1"
    find('.main').must_have_link "Title 2"
    find('.main').must_have_link "Title 3"
  end

  it "latest 3 posts" do
    visit "posts/new"
    new_post!("Title 1")
    #approve to test the searching
    approve_post!(::Post.last.id)

    find('.right-bar').must_have_link "Title 1"

    visit "posts/new"
    new_post!("Title 2")
    #approve to test the searching
    approve_post!(::Post.last.id)
    find('.right-bar').must_have_link "Title 1"
    find('.right-bar').must_have_link "Title 2"

    visit "posts/new"
    new_post!("Title 3")
    #approve to test the searching
    approve_post!(::Post.last.id)
    find('.right-bar').must_have_link "Title 1"
    find('.right-bar').must_have_link "Title 2"
    find('.right-bar').must_have_link "Title 3"

    visit "posts/new"
    new_post!("Title 4") 
    #approve to test the searchin
    approve_post!(::Post.last.id)
    find('.right-bar').must_have_link "Title 2"
    find('.right-bar').must_have_link "Title 3"
    find('.right-bar').must_have_link "Title 4"
    find('.right-bar').wont_have_link "Title 1"
  end
end