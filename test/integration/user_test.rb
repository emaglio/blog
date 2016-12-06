require 'test_helper'

class UsersIntegrationTest < Trailblazer::Test::Integration

  let!(:user2) {(User::Create.(email: "test2@email.com", password: "password", confirm_password: "password", firstname: "User2")).model}

  it "create user" do 
    visit 'users/new'

    page.must_have_css "#firstname"
    page.must_have_css "#lastname"
    page.must_have_selector ("#gender")
    page.must_have_css "#phone"
    page.must_have_css "#age"
    page.must_have_css "#email"
    page.must_have_css "#password"
    page.must_have_css "#confirm_password"
    page.must_have_button "Create User"

    #empty
    sign_up!("","")
    page.must_have_content "must be filled"
    page.current_path.must_equal "/users"

    #successfully create user
    sign_up!("test@email.com", "confirm_password")
    page.must_have_content "Hi, UserFirstname"
    page.must_have_content "Sign Out"
    page.current_path.must_equal "/posts"

    #sign_out and try to create user with the same email
    click_link "Sign Out"

    visit 'users/new'
    sign_up!("test@email.com", "confirm_password")
    page.must_have_content "Another user has been created with this email address"
    page.current_path.must_equal "/users"
  end

  it "update" do
    log_in_as_user("my@email.com", "password")

    user = User.find_by(email: "my@email.com")

    visit user_path(user.id)

    page.must_have_content "my@email.com"
    page.must_have_content "UserFirstname"
    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Change Password"

    #update user
    click_link "Edit"
    page.must_have_css "#firstname"
    page.must_have_css "#lastname"
    page.must_have_selector ("#gender")
    page.must_have_css "#phone"
    page.must_have_css "#age"
    page.must_have_css "#email"
    page.current_path.must_equal "/users/#{user.id}/edit"
    page.must_have_button "Save"
    
    #set NewFirstname as firstname    
    within("//form[@id='edit_user']") do
      fill_in 'Firstname',    with: "NewFirstname"
    end
    click_button "Save"

    page.must_have_content "Hi, NewFirstname"
    page.current_path.must_equal "/users/#{user.id}"

    #user2 trying to update user
    click_link "Sign Out"

    visit 'sessions/new'
    user2 = User.find_by(email: "test2@email.com")
    submit!(user2.email, "password")

    page.must_have_content "Hi, User2"
    
    visit user_path(user.id)
    page.current_path.must_equal "/posts"
    #test flash error

    visit "/users/#{user.id}/edit"
    page.current_path.must_equal "/posts"
    #test flash error
  end

  it "delete" do 
    log_in_as_user("my@email.com", "password")
    user = User.find_by(email: "my@email.com")

    page.must_have_link "Hi, UserFirstname"

    click_link "Hi, UserFirstname"

    page.must_have_link "Edit"
    page.must_have_link "Delete"
    page.must_have_link "Change Password"

    click_link "Delete"

    # test flash message

    visit "/sessions/new"

    submit!("my@email.com", "password")

    page.must_have_content "User not found"
  end

  it "change password" do 
    log_in_as_user("my@email.com", "password")
    user = User.find_by(email: "my@email.com")

    page.must_have_link "Hi, UserFirstname"

    click_link "Hi, UserFirstname"

    page.must_have_link "Change Password"

    click_link "Change Password"

    page.must_have_css "#password"
    page.must_have_css "#new_password"
    page.must_have_css "#confirm_new_password"

    within("//form[@id='change_password']") do
      fill_in 'Password', with: "password"
      fill_in 'New Password', with: "new_password"
      fill_in 'Confirm New Password', with: "new_password"
    end
    click_button "Change Password"

    # test flash message

    click_link "Sign Out"

    visit "/sessions/new"

    submit!("my@email.com", "password")
    page.must_have_content "Wrong Password"

    submit!("my@email.com", "new_password")
    page.must_have_link "Hi, UserFirstname"
  end

end