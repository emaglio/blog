module Post::Cell
  class Index < Trailblazer::Cell

  end

  class Item < Trailblazer::Cell
    def title
       link_to model.title, model
    end

    def subtitle
      link_to model.content["subtitle"], model      
    end

    def author
      if model.content["user_id"] != nil and User.find(model.content["user_id"]) != nil
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