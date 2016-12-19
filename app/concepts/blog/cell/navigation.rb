module Blog::Cell
  
  module Tyrant
    def tyrant
      context[:tyrant]
    end
  end

  module Policy
    def policy
      context[:policy]
    end
  end

  class Navigation < Trailblazer::Cell
    include Policy
    include Tyrant

    def welcome
      @name = tyrant.current_user.firstname

      if @name == nil
        @name = tyrant.current_user.email
      end

      "Hi, " + @name.to_s
    end

    def admin?
      return tyrant.current_user.email = "admin@email.com"
    end
  end
end