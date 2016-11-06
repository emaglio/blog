class User < ActiveRecord::Base
  class Edit < Create
    include Model
    model User, :find    
  end
end