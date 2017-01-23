require_dependency "post/operation/edit"

class Post::Update < Trailblazer::Operation
  step Nested(::Post::Edit)
  step Contract::Validate()
  step Contract::Persist()
  step :update!

  def update!(options, model:, **)
    model.save    
  end
end