class Post < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    
    policy Session::Policy, :update_delete_post?

    include Model
    model Post, :find

    def process(params) 
      model.destroy
    end 
  end

end