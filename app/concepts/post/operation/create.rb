require 'reform/form/dry'
require 'post/operation/new'

class Post::Create < Trailblazer::Operation
  step Nested(Post::New)
  step Contract::Validate()
  step Contract::Persist(method: :sync)
end
