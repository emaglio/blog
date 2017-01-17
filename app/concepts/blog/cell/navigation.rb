module Blog::Cell
  
  class NavigationMenu < Trailblazer::Cell
    def welcome
      @name = options["current_user"].firstname

      if @name == nil
        @name = options["current_user"].email
      end

      "Hi, " + @name.to_s
    end

    def admin?
      return options["current_user"].email == "admin@email.com"
    end

    def signed_in?
      return options["current_user"] != nil
    end

  end

  class Navigation < Trailblazer::Cell
    
  end
end