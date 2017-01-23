require_dependency 'post/lib/error_handler'
require_dependency 'session/lib/throw_exception'
require_dependency 'post/contract/create'

class Post::Edit < Trailblazer::Operation 
  step Model(Post, :find_by)
  failure Post::Lib::Error
  step Policy::Pundit( ::Session::Policy, :update_delete_post? )
  failure ::Session::Lib::ThrowException
  step Contract::Build(constant: Post::Contract::Update)
end