require_dependency 'post/lib/error_handler'
require_dependency 'session/lib/throw_exception'

class Post::Show < Trailblazer::Operation
  step Model(Post, :find_by)
  failure Post::Lib::Error, fail_fast: :true
  step :approved!
  failure ::Session::Lib::ThrowException

  def approved!(options, model:, current_user:, **)
    if admin_or_owner?(current_user, model)
      true
    else
      model.status == "Approved"
    end
  end
private
  def admin_or_owner?(current_user, model)
    current_user == nil ? false : (current_user.id == model.user_id or current_user.email == "admin@email.com")
  end
end