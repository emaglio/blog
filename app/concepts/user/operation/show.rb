class User < ActiveRecord::Base
  class Show < Create 
    include Model
    model User, :find

    policy Session::Policy, :show_block_user?
  end
end