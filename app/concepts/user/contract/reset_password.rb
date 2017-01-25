require 'reform/form/dry'

module User::Contract 
  class ResetPassword < Reform::Form 
    feature Reform::Form::Dry
    property :email, virtual: true
    
    validation do
      configure do
        option :form 
        config.messages_file = 'config/error_messages.yml'

        def user_exists?
          User.where(email: form.email).size == 1
        end
      end
        
      required(:email).filled(:user_exists?)
    end
  end
end