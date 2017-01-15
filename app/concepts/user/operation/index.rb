require 'session/lib/exception_thrower'

class User::Index < Trailblazer::Operation
  step Policy::Pundit( ::Session::Policy, :admin?)
  failure ::Session::Lib::ExceptionThrower.()
  stpe :model!

  def model!(options, *)
    result["model"] = User.all      
  end
end