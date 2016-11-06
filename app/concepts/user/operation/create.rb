require 'reform/form/dry'

class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model

    model User, :create

    contract do
      include Reform::Form::Dry

      property :firstname
      property :lastname
      property :email
      property :gender
      property :phone
      property :age
      property :block
      property :password, virtual: true
      property :confirm_password, virtual: true

      validation do
        VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

        required(:email).filled
        required(:email).filled(format?: VALID_EMAIL_REGEX)
        # required(:password).filled
        # required(:confirm_password).filled

        # required(:password_ok?).??  

        # def password_ok?
        #   return unless email and password
        #   errors.add(:password, "Passwords don't match") if password != confirm_password
        # end

      end
    end

    def process(params)
      validate(params) do
        contract.save
      end
    end
  end
end