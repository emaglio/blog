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
        contract.save
      end
    end

  end
end