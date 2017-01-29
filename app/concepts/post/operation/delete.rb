class Post::Delete < Trailblazer::Operation
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :update_delete_post?)
  failure ::Session::Lib::ThrowException
  step :notify!
  step :delete!

  def notify!(options, model:, **)
    Notification::Post.({}, "post" => model, "type" => "delete")
  end

  def delete!(options, model:, **) 
    model.destroy
  end 

end