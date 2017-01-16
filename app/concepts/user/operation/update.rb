require 'session/lib/throw_exception'

class User::Update < Trailblazer::Operation
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException.()
  step Model(User, :find_by)
  step Contract::Build(constant: ::User::Contract::New)
  step Contract::Validate()
  step Contract::Persist(method: :sync)
  step :update!

  def update!(options, *)
    model.save
  end
end