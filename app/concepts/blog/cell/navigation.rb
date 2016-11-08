module Blog::Cell
  class Navigation < Trailblazer::Cell

    def welcome
      "Hi, " + tyrant.current_user.firstname
    end

  private
    def tyrant
      context[:tyrant]
    end
  end
end