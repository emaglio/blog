module User::Cell
  class Index < Trailblazer::Cell
    
  end

  class Item < Trailblazer::Cell
    def link
      link_to params["email"], user_path(params["id"])
    end
  end
end