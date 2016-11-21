module User::Cell
  class Edit < New

    def back
      link_to "Back", user_path(model)  
    end
  end
end