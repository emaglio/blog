class Post < ActiveRecord::Base
  class Show < Create

    include Model
    model Post, :find

  end
end