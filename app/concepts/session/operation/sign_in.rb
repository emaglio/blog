module Session

  class SignIn < Trailblazer::Operation

    contract do
      undef :persisted? # TODO: allow with trailblazer/reform.
      attr_reader :user
      
      property :email,    virtual: true
      property :password, virtual: true

      validates :email, :password, presence: true
      validate :password_ok?
      validate :block?

    private
      def password_ok?
        return if email.blank? or password.blank? # TODO: test me.

        # @op.call
        @user = User.find_by(email: email)

        unless @user
          errors.add(:email, "User not found")
        else
          # DISCUSS: move validation of PW to Op#process?
          errors.add(:password, "Wrong password.") unless Tyrant::Authenticatable.new(@user).digest?(password)#
        end
      end

      def block?
        return if email.blank? or password.blank?

        @user = User.find_by(email: email)
        if @user
          errors.add(:email, "You have been blocked") if @user.block == true
        end
      end
    end

    def process(params)
      # model = User.find_by_email(email) 00000> pass user into form?
      validate(params[:session]) do |contract|
         # Monban.config.sign_in_service.new(contract.user).perform
        @model = contract.user
      end
    end
  
  end
end