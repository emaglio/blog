module Post::Cell
  class Show < Trailblazer::Cell
    property :title
    property :content

    def back
      link_to "Back to posts list", posts_path
    end

    def edit
      link_to "Edit", edit_post_path(model.id)
    end

    def delete
      link_to "Delete", post_path(model), method: :delete
    end
  end
end
