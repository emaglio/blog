require 'session/lib/exception_thrower'

class User::Update < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ExceptionThrower.()
  step :update!

  def update!(options, contract:, **)
    contract.save
  end
end