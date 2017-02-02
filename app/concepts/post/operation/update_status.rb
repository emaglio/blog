require_dependency 'session/lib/throw_exception'

class Post::UpdateStatus < Trailblazer::Operation
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :admin?)
  failure ::Session::Lib::ThrowException 
  step :update_status!
  step :notify!

  def update_status!(options, model:, params:, **)
    model.status = params[:status]
    model.save
  end

  def notify!(options, model:, params:, **)
    
    Notification::Post.({}, "post" => model, "message" => "params[:message]", "type" => "#{model.status}") unless model.status == "Pending"
  end
end