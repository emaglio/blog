class User < ActiveRecord::Base
  class Block < Trailblazer::Operation
    
    include Model
    model User, :find
    
    policy Session::Policy, :admin?

    contract Contract::Create do
      property :block, virtual: true
      validation do
        required(:block).filled
      end
    end

    def process(params)
      validate(params) do
        model.block = params[:block]
        model.save
      end
    end

  end
end