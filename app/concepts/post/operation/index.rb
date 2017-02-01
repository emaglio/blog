class Post::Index < Trailblazer::Operation
  step :model!

  def model!(options, current_user:, **)
    if current_user != nil and current_user.email == "admin@email.com"
      options["model"] = Post.all.reverse_order 
    else
      options["model"] = Post.where("status like ?", "Approved").reverse_order 
    end
  end 
end