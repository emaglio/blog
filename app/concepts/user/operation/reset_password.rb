require 'tyrant'
require 'reform/form/dry'

class User < ActiveRecord::Base
  class ResetPassword < Trailblazer::Operation
    include Model
    
    model User, :create

    contract do
      feature Reform::Form::Dry
      property :email, virtual: true
      validation do


        configure do
          config.messages_file = 'config/error_messages.yml'

          def user_exists?(email)
            User.where(email: email).size >= 1
          end
        end
          
        required(:email).filled(:user_exists?)
      end
    end
    
    def process(params)
      validate(params) do
        reset = Tyrant::ResetPassword.new()
        newModel = reset.new_authentication(params)
        raise newModel.inspect
        op = User::Update.(newModel)
      end
    end

  end 

  class GetEmail < Trailblazer::Operation
  end
end
