require 'session/lib/throw_exception'

class Post::Edit < Trailblazer::Operation 
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :update_delete_post? )
  failure Session::Lib::ThrowException.()
  step Contract::Build(constant: Post::Create)
end