module Blog::Cell

  module MyPosts
    def posts
      post_array = []
      #get the last 3 posts 
      # in case there are more than 3
      if ::Post.all.size < 3
        post_array << Post.all
      else
        i = 0
        (1..3).each do
          dim = ::Post.all.size
          while ::Post.where("id == ?",dim - i).size != 1 or dim-i != 0 do
            i =+1
          end
          post_array << ::Post.find(dim - i)
          i += 1
        end
      end
      return post_array
    end
  end


  class News < Trailblazer::Cell
    include MyPosts

    def show
      cell(Post, collection: posts)      
    end
  
    class Post < Trailblazer::Cell
      def link  
        raise model.inspect
        link_to model.title, post_path(model)
      end
    end
  end
end
