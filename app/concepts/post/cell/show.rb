module Post::Cell

  module Tyrant
    def tyrant 
      context[:tyrant]
    end
  end

  class Show < Trailblazer::Cell
    include Tyrant
    
    property :title
    property :content


    def back
      link_to "Back to posts list", posts_path
    end

    def edit
      if tyrant.current_user.id.to_s == model.content["user_id"] or tyrant.current_user.email == "admin@email.com" #change in order to have policy
        link_to "Edit", edit_post_path(model.id)
      end
    end

    def delete
      if tyrant.current_user.id.to_s == model.content["user_id"] or tyrant.current_user.email == "admin@email.com" #change in order to have policy
        link_to "Delete", post_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}
      end
    end

    def author
      if model.content["user_id"] != nil and tyrant.current_user != nil and tyrant.current_user.email == User.find(model.content["user_id"]).email
        link_to model.content["author"], user_path(model.content["user_id"])
      else
        return model.content["author"].to_s
      end   
    end

    def time
      model.created_at
    end
  end
end
