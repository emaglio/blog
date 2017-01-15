# require 'tyrant'

class User::ResetPassword < Trailblazer::Operation
  step Contract.Build(constant: ::User::Contract::ResetPassword)
  step Contract.Validate()
  step :reset!

  def reset!(options, *)
    user = User.find_by(email: params[:email])
    # Tyrant::ResetPassword.(model: user)
  end
end


class User::GetEmail < Trailblazer::Operation
end
