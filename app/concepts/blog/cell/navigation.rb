module Blog::Cell
  class Navigation < Trailblazer::Cell

    def welcome
      @name = tyrant.current_user.content["firstname"]

      if @name == nil
        @name = tyrant.current_user.email
      end

      "Hi, " + @name.to_s
    end

  private
    def tyrant
      context[:tyrant]
    end
  end
end