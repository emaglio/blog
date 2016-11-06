class User < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    include Model
    model User, :find

    def process(params)
      model.destroy
    end

  end
end