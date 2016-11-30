class User < ActiveRecord::Base
  class Update < Trailblazer::Operation

    policy Session::Policy, :update_delete_user?

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