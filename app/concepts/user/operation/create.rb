class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model

    model User, :create

    contract Contract::Create

    def process(params)
      validate(params) do
        contract.save
      end
    end
  end
end