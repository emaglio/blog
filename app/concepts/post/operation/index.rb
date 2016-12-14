class Post < ActiveRecord::Base
  class Index < Trailblazer::Operation

    def model!(params)
      Post.all.reverse_order
    end 
    
  end
end