require 'reform/form/dry'

module User::Contract 
  class Create < Reform::Form 
    feature Reform::Form::Dry
    property :password, virtual: true
    property :confirm_password, virtual: true

    validation do
      configure do
        option :form
        config.messages_file = 'config/error_messages.yml'
        
        def must_be_equal?
          return form.password == form.confirm_password
        end
      end
      
      required(:password).filled
      required(:confirm_password).filled

      validate(must_be_equal?: :confirm_password) do
        must_be_equal?
      end
    end
  end
end