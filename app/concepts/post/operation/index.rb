class Post::Index < Trailblazer::Operation
  step :model!

  def model!(options, *)
    options["model"] = Post.all.reverse_order
  end 
end