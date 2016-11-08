class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model

    model User, :create

    contract Contract::Create

    def process(params)
      validate(params) do
        update!
        contract.save
      end
    end

  private
    def update!
      auth = Tyrant::Authenticatable.new(contract.model)
      puts auth.inspect
      auth.digest!(contract.password) # contract.auth_meta_data.password_digest = ..
      auth.confirmed!
      auth.sync
    end
  end
end