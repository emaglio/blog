require 'post/lib/error_handler'

class Post::Show < Trailblazer::Operation
  step :test
  step Model(Post, :find_by)
  failure Post::Lib::Error

  def test(options, *)
    raise options.inspect
  end
end