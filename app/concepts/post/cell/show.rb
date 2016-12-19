module Post::Cell

  module Tyrant
    def tyrant 
      context[:tyrant]
    end
  end

  class Show < Trailblazer::Cell
    include Tyrant
    
    property :title
    property :subtitle
    property :body

    def back
      link_to "Back to posts list", posts_path
    end

    def edit
      unless tyrant.current_user == nil
        if tyrant.current_user.id == model.user_id or tyrant.current_user.email == "admin@email.com" #change in order to have policy
          link_to "Edit", edit_post_path(model.id)
        end
      end
    end

    def delete
      unless tyrant.current_user == nil
        if tyrant.current_user.id == model.user_id or tyrant.current_user.email == "admin@email.com" #change in order to have policy
          link_to "Delete", post_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}
        end
      end
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
