require 'test_helper'

class SessionsIntegrationTest < Trailblazer::Test::Integration
  
  it "invalid log in (not existing)" do
    visit "sessions/new"

    submit("","")
  end

  
end