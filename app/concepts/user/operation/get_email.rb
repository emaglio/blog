class User::GetEmail < Trailblazer::Operation
  step Contract.Build(constant: ::User::Contract::ResetPassword)
end