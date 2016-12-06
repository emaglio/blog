require 'tyrant'
require 'reform/form/dry'
require 'trailblazer'

class User < ActiveRecord::Base
  class ResetPassword < Trailblazer::Operation

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
        model = User.find_by(email: params[:email])
        Tyrant::ResetPassword.(model: model)
      end
    end

  end 

  class GetEmail < Trailblazer::Operation
  end
end
