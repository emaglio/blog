require 'reform/form/dry'

module Session

  class SignIn < Trailblazer::Operation

    contract do
      # feature Reform::Form::Dry
      undef :persisted? # TODO: allow with trailblazer/reform.
      attr_reader :user
      
      property :email,    virtual: true
      property :password, virtual: true

      # validation do

      #   configure do
      #     config.messages_file = 'config/error_messages.yml'

      #     def user_exists?(email)
      #       User.where(email: email).size == 1
      #     end


      #     def block?(email)
      #       user(email).content("block") != ("True")
      #     end
      #   end
        
      #   required(:email).filled(:user_exists?)
      #   required(:password).filled

        # rule(password_ok?: [:email, :password]) do |email, password|
        #   Tyrant::Authenticatable.new(User.find_by(email: email)).digest?(password).eql?("True")
        # end

      # end

      validates :email, :password, presence: true
      validate :password_ok?

    private
      def password_ok?
        @user = User.find_by(email: email)

        if @user
          Tyrant::Authenticatable.new(@user).digest?(password)
        end
      end
    end

    def process(params)
      validate(params) do |contract|
        @model = contract.user
      end
    end
  
  end
end
