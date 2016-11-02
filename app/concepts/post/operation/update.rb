class Post < ActiveRecord::Base
  class Update < Create

    include Model
    model Post, :find

  end
end