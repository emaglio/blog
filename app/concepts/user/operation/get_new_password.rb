require_dependency 'session/lib/throw_exception'

class User::GetNewPassword < Trailblazer::Operation
  step Contract::Build(constant: User::Contract::ChangePassword) 
end