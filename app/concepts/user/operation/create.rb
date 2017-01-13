require 'reform/form/dry'

class User::Create < Trailblazer::Operation
  step Nested(User::New)
  step Contract::Validate()
  step :update!
  step Contract::Persist(method: :sync)

  def update!(options, contract:, *)
    auth = Tyrant::Authenticatable.new(contract.model)
    auth.digest!(contract.password) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
  end
end