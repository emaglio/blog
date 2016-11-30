class User < ActiveRecord::Base
  class Index < Trailblazer::Operation

    policy Session::Policy, :admin?

    def model!(params)
      User.all      
    end
    
  end
end