class User < ActiveRecord::Base
  class Update < Create 
    include Model
    model User, :find
  end
end