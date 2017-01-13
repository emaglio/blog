module Session
  class SignIn < Trailblazer::Operation
    step Contract::Build(constant: Session::Contract::SignIn)
    step Contract::Validate()
    step :model!    

    def model!(options, *)
      result["model"] = get_user(params)
    end 
  private
    def get_user(params)
      return User.find_by(email: params[:email])
    end
  end
end