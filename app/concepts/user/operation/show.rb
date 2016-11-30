class User < ActiveRecord::Base
  class Show < Create 
    include Model
    model User, :find

    policy Session::Policy, :update_delete_user?
  end
end