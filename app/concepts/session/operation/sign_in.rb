require 'reform/form/dry'

module Session

  class SignIn < Trailblazer::Operation

    contract do
      feature Reform::Form::Dry
      undef :persisted? # TODO: allow with trailblazer/reform.
      attr_reader :user
      
      property :email,    virtual: true
      property :password, virtual: true

      validation :defaul do

        configure do
          config.messages_file = 'config/error_messages.yml'

          def user(email)
            return User.find_by(email: email)
          end

          def user_exists?(email)
            User.where(email: email).size == 1
          end

          def password_ok?(email,password)
            Tyrant::Authenticatable.new(user(email)).digest?(password) == ("True")
          end

          def block?(email)
            user(email).content("block") != ("True")
          end
        end
        
      required(:email).filled(:user_exists?)
      required(:password).filled(:password_ok?)

      end
    end

    def process(params)
      validate(params) do |contract|
        @model = contract.user
      end
    end
  
  end
end