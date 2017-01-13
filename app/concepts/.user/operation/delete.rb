class User < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    include Model
    model User, :find

    policy Session::Policy, :current_user?

    def process(params)
      model.destroy
    end

  end
end