require 'session/lib/exception_thrower'

class User::Block < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :admin?)
  failure Session::Lib::ExceptionThrower.()
  step Contract::Build(constant: User::Contract::Block)
  step Contract::Validate()
  step :model!

  def model!(options, params:, model:, **)
    model.block = params[:block]
    model.save
  end

end