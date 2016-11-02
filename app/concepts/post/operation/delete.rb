class Post < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    include Model
    model Post, :find

    def process(params) 
      model.destroy
    end 
  end

end