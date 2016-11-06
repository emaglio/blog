class User < ActiveRecord::Base
  class Index < Trailblazer::Operation

    def process!(params)
      User.all      
    end
    
  end
end