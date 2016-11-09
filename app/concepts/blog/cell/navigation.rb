module Blog::Cell
  class Navigation < Trailblazer::Cell

    def welcome
      # raise tyrant.inspect

      # "Hi, " + tyrant.current_user.firstname
    end

  private
    def tyrant
      context[:tyrant]
    end
  end
end