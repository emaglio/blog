class User < ActiveRecord::Base
  class Update < Trailblazer::Operation

    policy Session::Policy, :current_user?

    include Model
    model User, :find    

    contract Contract::Create do

      property :email

      validation do
        configure do
          option :form
          config.messages_file = 'config/error_messages.yml'

          def email?(value)
            ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(value).nil?
          end
        end
        required(:email).filled(:email?)
      end
    end

    def process(params)
      validate(params) do
        contract.save
      end
    end
  end
end