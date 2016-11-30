class User < ActiveRecord::Base
  class Show < Create 
    include Model
    model User, :find

    policy Session::Policy, :current_user?
  end
end