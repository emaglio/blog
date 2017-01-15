require 'session/lib/exception_thrower'

class User::Show < Trailblazer::Operation 
  step Policy::Pundit( ::Session::Policy, :show_block_user?)
  failure ::Session::Lib::ExceptionThrower.()
  step Model(User, :find_by)
end