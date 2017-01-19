require 'session/lib/throw_exception'

class User::Show < Trailblazer::Operation 
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :show_block_user?)
  failure ::Session::Lib::ThrowException.()
end