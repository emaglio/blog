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
        Tyrant::ResetPassword.(model)
        # user = User.find_by(email: params[:email])
        # reset = Tyrant::ResetPassword.new()
        # newModel = reset.new_authentication(user)
        # op = User::Update.(id: newModel.id, auth_meta_data: newModel.auth_meta_data)
        # contract.save
      end
    end

  end 

  class GetEmail < Trailblazer::Operation
  end
end
