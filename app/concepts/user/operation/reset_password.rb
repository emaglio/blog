require 'tyrant'
require 'reform/form/dry'

class User < ActiveRecord::Base
  class ResetPassword < Trailblazer::Operation
    include Model
    
    model User, :find

    def process(param)
      reset = Tyrant::ResetPassword.new()
      newModel = reset.new_authentication(params)
      raise newModel.inspect
      op = User::Update.(newModel)
    end

  end 
end