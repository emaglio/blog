class Post::Delete < Trailblazer::Operation
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :update_delete_post?)
  step :delete!

  def delete!(options, model:, **) 
    model.destroy
  end 
end