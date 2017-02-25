require 'reform/form/prepopulate'

class Post::New < Trailblazer::Operation 
  step Model(Post, :new)
  step Contract::Build(constant: Post::Contract::Create)    
  # step ->(options) {raise options["contract.default"].inspect}
end