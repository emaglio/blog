module Blog::Cell
  class News < Trailblazer::Cell
    def users
      return User.last.content["firstname"]
    end
    
    def posts
      return Post.last.title
    end
  end
end
