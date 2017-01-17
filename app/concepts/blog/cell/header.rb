module Blog::Cell

  class Header < Trailblazer::Cell
    def show_post
      return model.show_post
    end

    def post_exist?
      return Post.where("id like ?", model.show_id).size == 1
    end
    
    def post
      return Post.find(model.show_id) if show_post and post_exist?
    end
    
    def title
      if show_post and post_exist?
        return post.title
      else
        return "TRB Blog"
      end
    end

    def subtitle
      if show_post and post_exist?
        return post.subtitle
      else
        return "A Blog implemented with TRB/Dry-validation/Formular"
      end
    end


    def container
      if show_post and post_exist?
        return "post-heading"
      else
        return "site-heading"
      end
    end

    def image
      if show_post and post_exist?
        return '/assets/post-bg.jpg'
      else
        return '/assets/home-bg.jpg'
      end
    end

    def dec
      if show_post and post_exist?
        return ''
      else
        return 'small'
      end
    end
    
    def author
      if show_post and post_exist?
        if options["current_user"] != nil and post.user_id != nil and options["current_user"].email == User.find(post.user_id).email
          return "Me"
        else
          return post.author
        end
      end   
    end

    def time
      post.created_at if show_post and post_exist?
    end


  end
end