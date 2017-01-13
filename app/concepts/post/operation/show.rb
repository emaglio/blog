require 'post/lib/error_handler'

class Post::Show < Trailblazer::Operation
  step Model(Post, :find_by)
  failure Post::Lib::Error
end