require_dependency 'session/lib/throw_exception'

class Post::UpdateStatus < Trailblazer::Operation
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :admin?)
  failure ::Session::Lib::ThrowException 
  step :update_status!

  def update_status!(options, model:, params:, **)
    model.status = params[:status]
    model.save
  end
  
end