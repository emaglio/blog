module Blog::Cell

  module MyPosts
    def posts
      post_array = []
      #get the last 3 posts 
      # in case there are more than 3
      if Post.where("status like ?", "Approved").size < 3
        post_array = Post.where("status like ?", "Approved")
      else
        i = 1
        (1..3).each do
          all_posts = Post.where("status like ?", "Approved")
          post_array << all_posts[-i]
          i += 1
        end
      end
      return post_array
    end
  end


  class News < Trailblazer::Cell
    include MyPosts

    def show
      posts.size == 1 ? cell(Post, posts.first) : cell(Post, collection: posts)
    end
  
    class Post < Trailblazer::Cell
      def link  
        link_to model.title, post_path(model)
      end
    end
  end
end