require_dependency 'post/operation/new'

class Post::Create < Trailblazer::Operation
  step Nested(::Post::New)
  step Contract::Validate()
  step Contract::Persist()
  step :notify!

  def notify!(options, model:, **)
    Notification::Post.({}, "post" => model, "type" => "create")
  end
end
