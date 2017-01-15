require 'reform/form/dry'

module User::Contract 
  class Update < Reform::Form 
    feature Reform::Form::Dry
    property :email

    validation do
      configure do
        option :form
        config.messages_file = 'config/error_messages.yml'

        def email?(value)
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(value).nil?
        end

        def unique_email?
          User.where("email = ?", form.email).size == 0
        end
      end
      
      required(:email).filled(:email?, :unique_email?)
    end
  end
end