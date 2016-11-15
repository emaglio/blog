class User < ActiveRecord::Base
  class SavePassword < Trailblazer::Operation  
    include Model
    model User, :find

    contract do
      property :auth_meta_data
    end

    def process(params)
      contract.save
    end
  end
end