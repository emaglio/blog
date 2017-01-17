require 'post/lib/error_handler'
require 'session/lib/throw_exception'
require 'post/contract/create'

class Post::Update < Trailblazer::Operation
  step Model(Post, :find_by)
  failure Post::Lib::Error
  # step :test
  step Policy::Pundit( ::Session::Policy, :update_delete_post? )
  failure ::Session::Lib::ThrowException
  step Contract::Build(constant: Post::Contract::Create)
  step Contract::Validate()
  step Contract::Persist()

  # def test(options, *)
  #   puts options.inspect
  # end
end