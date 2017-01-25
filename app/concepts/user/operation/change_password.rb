require_dependency 'user/operation/get_new_password'

class User::ChangePassword < Trailblazer::Operation
  step Nested(User::GetNewPassword)
  step Contract::Validate()
  failure :abort!,                                fail_fast: true
  step :model!
  step Policy::Pundit(::Session::Policy, :current_user?)   
  failure Session::Lib::ThrowException
  step :update!   

  def model!(options, params:, **)
    options["model"] = User.find_by(email: params[:email])
  end

  def abort!(options, *)
  end

  def update!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:new_password]) # contract.auth_ meta_data.password_digest = ..
    auth.sync
    model.save
  end
end