require 'reform/form/dry' 

class User::ChangePassword < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)   
  failure Session::Lib::ExceptionThrower.()
  step Contract::Build(constant: User::Contract::ChangePassword) 
  step Contract::Validate()
  step :update!   

  def update!(options, contract:, **)
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.digest!(contract.new_password) # contract.auth_ meta_data.password_digest = ..
      auth.confirmed!
      auth.sync
      model.save
  end
end