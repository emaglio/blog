class Post < ActiveRecord::Base
  class Edit < Create

    include Model
    model Post, :find

  end
end