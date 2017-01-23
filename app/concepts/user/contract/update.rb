require 'reform/form/dry'

module User::Contract 
  class Update < Reform::Form 
    feature Reform::Form::Dry

    property :email
    property :firstname
    property :lastname
    property :gender
    property :phone
    property :age
    property :id

    validation do
      configure do
        option :form
        config.messages_file = 'config/error_messages.yml'
        
        def unique_email?
          return true if User.find(form.id).email == form.email
          User.where("email = ?", form.email).size == 0 
        end

        def email?(value)
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(value).nil?
        end
      end
      
      #if present must have the correct format and must be unique
      optional(:email).filled(:email?)

      validate(unique_email?: :email) do
        unique_email?
      end
    end
  end
end