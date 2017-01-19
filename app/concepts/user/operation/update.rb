require 'session/lib/throw_exception'

class User::Update < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException.()
  step Contract::Build(constant: ::User::Contract::New)
  step Contract::Validate()
  step Contract::Persist()
  step :update!

  def update!(options, *)
    model.save
  end
end