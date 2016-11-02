ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require "minitest/autorun"

Minitest::Spec.class_eval do
  after :each do
    # DatabaseCleaner.clean
    # ::Post.delete_all
  end
end
