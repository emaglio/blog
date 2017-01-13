class Post::Index < Trailblazer::Operation
  step :model!

  def model!(options, *)
    result["model"] = Post.all.reverse_order
  end 
end