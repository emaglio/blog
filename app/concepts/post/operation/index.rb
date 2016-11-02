class Post < ActiveRecord::Base
  class Index < Trailblazer::Operation

    def model!(params)
      Post.all
    end 
    
  end
end