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
  end
end

Trailblazer::Test::Integration.class_eval do
  def submit!(email, password)
    puts page.body
    within(:xpath, "//form[@id='new_session']") do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end
    click_button "Sign In"
  end
end

#to test that a new password "NewPassword" is actually saved 
#in the auth_meta_data in User
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
