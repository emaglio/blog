require_dependency 'session/lib/throw_exception'

class User::GetNewPassword < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)   
  failure Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::ChangePassword) 
end