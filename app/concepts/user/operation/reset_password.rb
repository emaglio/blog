require 'tyrant'
require 'reform/form/dry'

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
        reset = Tyrant::ResetPassword.new()
        user = User.find_by(email: params[:email])
        new_model = reset.new_authentication(user)
        User::SavePassword.(id: user.id, auth_meta_data: new_model[:auth_meta_data]) 
      end
    end

  end 

  class GetEmail < Trailblazer::Operation
  end
end
