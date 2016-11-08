require 'reform/form/dry'

class User < ActiveRecord::Base
  class WebCreate < Create 
    
    contract Contract::Create do
      feature Reform::Form::Dry
      property :confirm_password, virtual: true
      
      validation do
        required(:confirm_password).filled

        rule(must_be_equal?: [:password, :confirm_password]) do |a, b|
          a.eql?(b) 
        end
        configure { config.messages_file = 'config/error_messages.yml' }
      end
    end

    def process(params)
      validate(params) do
        update!
        contract.save
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