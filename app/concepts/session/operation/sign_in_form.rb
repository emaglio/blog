class Session::SignInForm < Trailblazer::Operation
  step Contract::Build(constant: Session::Contract::SignIn)
end