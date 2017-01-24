require_dependency 'tyrant'
require_dependency 'user/operation/get_email'


class User::ResetPassword < Trailblazer::Operation
step Nested(User::GetEmail)
  step Contract.Validate()
  step :reset!

  def reset!(options, params:, **)
    user = User.find_by(email: params[:email])
    Tyrant::ResetPassword.( {}, "model" => user )
  end
end



