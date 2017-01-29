require_dependency 'session/lib/throw_exception'

class User::Delete < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException
  step :notify!
  step :delete!

  def notify!(options, model:, **)
    Notification::User.({}, "email" => model.email, "type" => "delete")
  end

  def delete!(options, model:, **)
    model.destroy
  end
end