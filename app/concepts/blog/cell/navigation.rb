module Blog::Cell
  class Navigation < Trailblazer::Cell

    def welcome
      @name = tyrant.current_user.content["firstname"]

      if @name == nil
        @name = tyrant.current_user.email
      end

      "Hi, " + @name.to_s
    end

    def admin? #change in order to use policy.admin?
      return tyrant.current_user.email == "admin@email.com"
    end

  end
end