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

Tyrant::ResetPassword.class_eval do #thinking to override this to simply test this function
#   def process(params) 
#   end

# private
#   def new_auth(params)

#   end
end
