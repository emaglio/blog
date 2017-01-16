require 'session/lib/throw_exception'

class User::Delete < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException.()
  step :delete!

  def delete!(options, model:, **)
    model.destroy
  end
end