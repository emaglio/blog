require 'reform/form/dry' 

class User::ChangePassword < Tyrant::ChangePassword
  failure :raise_error!
  step :notify!

  def raise_error!(options, *)
    raise ApplicationController::NotAuthorizedError if options["result.policy.default"].failure?
  end

  def notify!(options, current_user:, **)
    Notification::User.({}, "email" => current_user.email, "type" => "change_password")
  end

end