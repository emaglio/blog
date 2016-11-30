module Post::Cell
  class Show < Trailblazer::Cell
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
        link_to "Delete", post_path(model.id), method: :delete
      end
    end
  end
end
