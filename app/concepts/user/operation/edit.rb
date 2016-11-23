class User < ActiveRecord::Base
  class Edit < Trailblazer::Operation

    policy Session::Policy, :current_user?

    include Model
    model User, :find    

    contract Contract::Create do
    end

    def process(params)
      validate(params) do
        contract.save
      end
    end
  end
end