require 'reform/form/dry' 

class User < ActiveRecord::Base
  class ChangePassword < Trailblazer::Operation
    
    include Model
    model User, :find
    
    policy Session::Policy, :current_user?
    
    contract do
      feature Reform::Form::Dry

      property :password, virtual: true
      property :new_password, virtual: true
      property :confirm_new_password, virtual: true

      validation do
        configure do
          option :form
          config.messages_file = 'config/error_messages.yml'

          def new_must_match?
            return form.new_password == form.confirm_new_password
          end

          def new_password_must_be_new?
            return form.password != form.new_password
          end

          def password_ok? #change this in order to run this only if user exists
            return Tyrant::Authenticatable.new(form.model).digest?(form.password) == true
          end

        end

        required(:password).filled(:password_ok?)
        required(:new_password).filled(:new_password_must_be_new?)
        required(:confirm_new_password).filled(:new_must_match?)
      end
    end

    def process(params)
      validate(params)do
        update!
        model.save
      end
    end

  private
    def update!
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.digest!(contract.new_password) # contract.auth_ meta_data.password_digest = ..
      auth.confirmed!
      auth.sync
    end
    
  end

  class GetNewPassword < Trailblazer::Operation
  end
end