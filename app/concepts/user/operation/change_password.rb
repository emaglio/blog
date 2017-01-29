require 'reform/form/dry' 

class User::ChangePassword < Trailblazer::Operation
  step Nested(Tyrant::ChangePassword)
  step :notify!

  def notify!(options, current_user:, **)
    Notification::User.({}, "email" => current_user.email, "type" => "change_password")
  end

end