require_dependency 'session/lib/throw_exception'

class User::Index < Trailblazer::Operation
  step Policy::Pundit( ::Session::Policy, :admin?)
  failure ::Session::Lib::ThrowException
  step :model!

  def model!(options, *)
    options["model"] = User.all      
  end
end