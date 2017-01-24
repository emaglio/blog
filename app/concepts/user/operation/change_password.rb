require_dependency 'user/operation/get_new_password'

class User::ChangePassword < Trailblazer::Operation
  step Nested(User::GetNewPassword)
  step Contract::Validate()
  step :update!   

  def update!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:new_password]) # contract.auth_ meta_data.password_digest = ..
    auth.sync
    model.save
  end
end