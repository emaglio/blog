require 'reform/form/dry'

module Session

  class SignIn < Trailblazer::Operation

    contract do
      feature Reform::Form::Dry
      undef :persisted? # TODO: allow with trailblazer/reform.
      attr_reader :user
      
      property :email,    virtual: true
      property :password, virtual: true

      validation do
        configure do
          messages_file = 'config/error_messages.yml'

          def user_exists?(email)
            User.find_by(email: email).size == (1)
          end

          def password_ok?(password)
            Tyrant::Authenticatable.new(@user).digest?(password) == ("True")
          end

          def block?(email)
            User.find_by(email: email).content("block") != ("True")
          end
        end
        
      required(:email).filled(:user_exists?)
      required(:password).filled(:password_ok?)

      end
    end

    def process(params)
      validate(params[:session]) do |contract|
        @model = contract.user
      end
    end
  
  end
end