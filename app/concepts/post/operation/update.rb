class Post < ActiveRecord::Base
  class Update < Create

    include Model
    model Post, :find

    policy Session::Policy, :update_delete_post?
  end
end