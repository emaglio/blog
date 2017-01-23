module Blog::Cell
  
  class NavigationMenu < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def welcome
      return "Hi, " + current_user.firstname if current_user.firstname != nil and current_user.firstname != ""

      "Hi, " + current_user.email
    end

    def admin?
      return current_user.email == "admin@email.com"
    end

    def signed_in?
      return current_user != nil
    end

  end

  class Navigation < Trailblazer::Cell
    
  end
end