require 'reform/form/dry'

module Session::Contract 
  class SignIn < Reform::Form
    feature Reform::Form::Dry
    undef :persisted?
    attr_reader :user
    
    property :email,    virtual: true
    property :password, virtual: true

    validation with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        # change this in order to have variable (@user) in order to have it available in the contract and
        # run just @model = contract.user instead of another find_by
        def user 
          return User.find_by(email: form.email)
        end

        def user_exists?
          return user != nil
        end

        def password_ok? #change this in order to run this only if user exists
          Tyrant::Authenticatable.new(user).digest?(form.password) == true if user != nil
        end

        def not_blocked?
          user.block == false or user.block == nil 
        end
      end
      
      required(:email).filled(:user_exists?)
      required(:password).filled

      #check if user is blocked only if email is filled and user exists
      validate(not_blocked?: :email) do
        not_blocked?
      end

      #verify password only if it has been filled first
      validate(password_ok?: :password) do
        password_ok?
      end
    end
  end
end