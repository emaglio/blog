class Session::SignIn < Trailblazer::Operation
  step Contract::Build(constant: Session::Contract::SignIn)
  step Contract::Validate()
  step :model!    

  def model!(options, params:, **)
    options["model"] = User.find_by(email: params[:email])
  end 
end
