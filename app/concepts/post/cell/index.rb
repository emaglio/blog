module Post::Cell
  class Index < Trailblazer::Cell

  end

  class Item < Trailblazer::Cell
    def title
       model.title
    end

    def subtitle
      model.subtitle      
    end
  end

end