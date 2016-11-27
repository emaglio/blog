module User::Cell
  class ChangePassword < New
    
    def tyrant
      context[:tyrant]
    end

    def back
      link_to "Back", user_path(tyrant.current_user)  
    end
  end
end