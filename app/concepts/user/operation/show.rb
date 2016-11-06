class User < ActiveRecord::Base
  class Show < Create 
    include Model
    model User, :find
  end
end