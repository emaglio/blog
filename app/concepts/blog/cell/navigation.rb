module Blog::Cell
  
  class NavigationMenu < Trailblazer::Cell
    def welcome
      @name = options[:context][:current_user].firstname

      if @name == nil
        @name = options[:context][:current_user].email
      end

      "Hi, " + @name.to_s
    end

    def admin?
      return options[:context][:current_user].email == "admin@email.com"
    end

    def signed_in?
      return options[:context][:current_user] != nil
    end

    def current_user
      return options[:context][:current_user]
    end
  end

  class Navigation < Trailblazer::Cell
    
  end
end