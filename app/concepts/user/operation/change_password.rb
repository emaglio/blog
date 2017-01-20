require_dependency 'session/lib/throw_exception'

class User::ChangePassword < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)   
  failure Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::ChangePassword) 
  step Contract::Validate()
  step :update!   

  def update!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:new_password]) # contract.auth_ meta_data.password_digest = ..
    auth.sync
    model.save
  end
end