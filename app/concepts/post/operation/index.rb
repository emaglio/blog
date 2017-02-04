class Post::Index < Trailblazer::Operation
  step :model!

  def model!(options, current_user:, params:, **)
    if current_user != nil and current_user.email == "admin@email.com"
      params[:status] != nil ? (options["model"] = Post.where("status like ?", params[:status]).reverse_order) : (options["model"] = Post.all.reverse_order)
    else
      params[:owner] == "true" ? (options["model"] = Post.where("user_id like ?", current_user.id).reverse_order) : (options["model"] = Post.where("status like ?", "Approved").reverse_order) 
    end
  end 
end