module User::Cell
  class Show < Trailblazer::Cell 
    property :email
    property :content

    def edit
      link_to "Edit", edit_user_path(model)
    end

    def delete
      link_to "Delete", user_path(model), method: :delete
    end
  end
end