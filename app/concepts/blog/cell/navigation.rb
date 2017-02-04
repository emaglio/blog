module Blog::Cell
  
  class NavigationMenu < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def welcome
      current_user.firstname.blank? ? "Hi, " + current_user.email : "Hi, " + current_user.firstname
    end

    def admin?
      return current_user.email == "admin@email.com"
    end

    def signed_in?
      return current_user != nil
    end

    def numPending
      Post.where("status like ?", "Pending").size
    end

    def numApproved
      Post.where("status like ?", "Approved").size
    end

    def numDeclined
      Post.where("status like ?", "Declined").size
    end

  end

  class Navigation < Trailblazer::Cell
    
  end
end