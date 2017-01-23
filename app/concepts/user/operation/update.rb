require_dependency 'user/operation/edit'

class User::Update < Trailblazer::Operation
  step Nested(::User::Edit)
  step Contract::Validate()
  step Contract::Persist()
  step :update!

  def update!(options, model:, **)
    model.save
  end
end