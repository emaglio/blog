ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'minitest/autorun'
require "trailblazer/rails/test/integration"
require 'tyrant'


Minitest::Spec.class_eval do
  after :each do
    # DatabaseCleaner.clean
    ::Post.delete_all
    ::User.delete_all
  end

  def admin_for
    User::Create.(email: "admin@email.com", password: "password", confirm_password: "password", firstname: "Admin").model unless User.find_by(email: "admin@email.com") != nil
  end
end

Cell::TestCase.class_eval do
  include Capybara::DSL
  include Capybara::Assertions
end

Trailblazer::Test::Integration.class_eval do
  # puts page.body
  def submit!(email, password)
    within("//form[@id='new_session']") do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end
    click_button "Sign In"
  end


  def sign_up!(email = "test@email.com", password = "password")
    within("//form[@id='new_user']") do
      fill_in 'Firstname',    with: "UserFirstname"
      fill_in 'Lastname',    with: "UserLastname"
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
      fill_in 'Confirm Password', with: password
      select('Male', :from => 'gender')
      fill_in 'Age', with: "31"
      fill_in 'Phone', with: "32343211"
    end
    click_button "Create User"
  end

  def log_in_as_admin
    User::Create.(email: "admin@email.com", password: "password", confirm_password: "password", firstname: "Admin").model unless User.find_by(email: "admin@email.com") != nil 
    
    visit "sessions/new"
    submit!("admin@email.com", "password")
  end

  def log_in_as_user(email = "my@email.com", password = "password")
    user = User::Create.(email: email, password: password, confirm_password: password, firstname: "UserFirstname").model unless User.find_by(email: email) != nil

    visit "sessions/new"
    submit!(user.email, "password")
  end

  def new_post!(title = "Title", subtitle = "Subtitle", body = "Body", author = "Author", signed_in = false)
    within("//form[@id='new_post']") do
      fill_in 'Title',  with: title
      fill_in 'Subtitle', with: subtitle
      fill_in 'What do you wanna say?', with: body
      if !signed_in
        fill_in 'Author', with: author
      end
    end
    click_button "Create Post"
  end

end

#to test that a new password "NewPassword" is actually saved 
#in the auth_meta_data of User
Tyrant::ResetPassword.class_eval do 
  def generate_password
    return "NewPassword"
  end
end

#to test the email notification to the user for the ResetPassword
Tyrant::Mailer.class_eval do 
  def email_options
    Pony.options = {via: :test}
  end  
end
