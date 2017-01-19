require 'user/operation/new'

class User::Create < Trailblazer::Operation
  step Nested(::User::New)
  step Contract::Validate()
  step Contract::Persist()
  step :create!

  def create!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:password]) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end
end