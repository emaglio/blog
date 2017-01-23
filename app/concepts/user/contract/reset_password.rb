require 'reform/form/dry'

module User::Contract 
  class ResetPassword < Reform::Form 
    feature Reform::Form::Dry
    property :email, virtual: true
    
    validation do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def user_exists?(email)
          User.where(email: email).size == 1
        end
      end
        
      required(:email).filled(:user_exists?)
    end
  end
end