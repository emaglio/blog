module User::Cell
  class Index < Trailblazer::Cell
    
  end

  class Item < Trailblazer::Cell
    def link
      link_to model.email, model unless model == nil
    end
  end
end