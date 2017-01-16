require 'session/lib/throw_exception'

class User::ChangePassword < Trailblazer::Operation
  step Policy::Pundit(::Session::Policy, :current_user?)   
  failure Session::Lib::ThrowException.()
  step Model(User, :find_by)
  step Contract::Build(constant: User::Contract::ChangePassword) 
  step Contract::Validate()
  step :update!   

  def update!(options, model:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(model.new_password) # contract.auth_ meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end
end