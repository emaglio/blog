require 'reform/form/dry'

class User < ActiveRecord::Base
  class Create < Trailblazer::Operation

    include Model
    include Mailer

    model User, :create

    contract Contract::Create do
      feature Reform::Form::Dry
      property :email
      property :password, virtual: true
      property :confirm_password, virtual: true

      validation do
        configure do
          option :form
          config.messages_file = 'config/error_messages.yml'
          
          def unique_email?
            User.where("email = ?", form.email).size == 0
          end

          def email?(value)
            ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(value).nil?
          end

          def must_be_equal?
            return form.password == form.confirm_password
          end
        end
        
        required(:email).filled(:email?)
        required(:password).filled
        required(:confirm_password).filled

        validate(unique_email?: :email) do
          unique_email?
        end

        validate(must_be_equal?: :confirm_password) do
          must_be_equal?
        end
      end
    end

    def process(params)
      validate(params) do
        update!
        contract.save
        Notification::User.(email: contract.email, type: "welcome")
      end
    end

  private
    def update!
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.digest!(contract.password) # contract.auth_meta_data.password_digest = ..
      auth.confirmed!
      auth.sync
    end
  end
end