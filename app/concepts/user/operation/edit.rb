class User < ActiveRecord::Base
  class Edit < Create
    include Model
    model User, :find    


    # def process(params)
    #   validate(params) do
    #     contract.save
    #   end
    # end
  end
end