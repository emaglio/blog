require 'session/lib/error_handler'

class Post::Update < Trailblazer::Operation
  step Model(Post, :find_by)
  failure Post::Lib::Error
  step Policy::Pundit( ::Session::Policy, :update_delete_post? )
  failure Session::Lib::ExceptionThrower
end