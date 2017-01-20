class Post::Delete < Trailblazer::Operation
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :update_delete_post?)
  failure ::Session::Lib::ThrowException
  step :delete!

  def delete!(options, model:, **) 
    model.destroy
  end 
end