require_dependency 'post/lib/error_handler'
require_dependency 'session/lib/throw_exception'

class Post::Show < Trailblazer::Operation
  step Model(Post, :find_by)
  failure Post::Lib::Error, fail_fast: :true
  step :approved!
  failure ::Session::Lib::ThrowException

  def approved!(options, model:, current_user:, **)
    if current_user == nil and current_user.email != "admin@email.com"
      options["result.validate"] = (model.status == "Declined" or model.status == "Pending")  
    else
      options["result.validate"] = true
    end
  end
end