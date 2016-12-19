module Post::Cell
  
  module Tyrant
    def tyrant
      context[:tyrant]
    end
  end

  class Index < Trailblazer::Cell
  private
    def total
      if model.size == 0
        return "No posts"
      end
    end
  end

  class Item < Trailblazer::Cell
    include Tyrant

    def title
      if model == nil
        return "No posts"
      else
        link_to model.title, model
      end
    end

    def subtitle
      link_to model.subtitle, model unless model == nil
    end

    def author
      if model.user_id != nil and tyrant.current_user != nil and tyrant.current_user.email == User.find(model.user_id).email
        link_to model.author, user_path(model.user_id)
      else
        return model.author
      end   
    end

    def time
      model.created_at
    end
  end

end