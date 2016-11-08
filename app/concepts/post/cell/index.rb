module Post::Cell
  class Index < Trailblazer::Cell

  end

  class Item < Trailblazer::Cell
    def title
       link_to model.title, model
    end

    def subtitle
      link_to model.subtitle, model      
    end

    def author
      link_to model.author
    end

    def time
      model.created_at
    end
  end

end