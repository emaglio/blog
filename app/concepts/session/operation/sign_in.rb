require_dependency 'session/operation/sign_in_form'

class Session::SignIn < Trailblazer::Operation
  step Nested(Session::SignInForm)
  step Contract::Validate()
  step :model!    

  def model!(options, params:, **)
    options["model"] = User.find_by(email: params[:email])
  end 
end
