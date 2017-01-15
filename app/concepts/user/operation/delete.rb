require 'session/lib/error_thrower'

class User::Delete < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ExceptionThrower.()
  step :delete!

  def delete!(options, model:, **)
    model.destroy
  end
end