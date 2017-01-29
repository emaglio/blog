require_dependency 'session/lib/throw_exception'

class User::Block < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :admin?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::Block)
  step Contract::Validate()
  step :model!
  step :notify!

  def model!(options, params:, model:, **)
    model[:block] = params[:block]
    model.save
  end
  
  def notify!(options, model:, **)
    Notification::User.({}, "email" => model.email, "type" => "block")
  end
end