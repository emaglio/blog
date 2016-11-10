module User::Cell
  class Show < Trailblazer::Cell 
    property :email
    property :content

    def edit
      raise model.inspect
      link_to "Edit", edit_user_path(model)
    end
  end
end