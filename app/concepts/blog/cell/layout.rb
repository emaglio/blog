module Blog::Cell
  class Layout < Trailblazer::Cell
    property :current_user
    property :real_user
    property :signed_in?

  private      
    def tyrant
      context[:tyrant]
    end

    def links
      render
    end

    def welcome_signed_in
      link_to("Hi, #{current_user.firstname}".html_safe, user_path(current_user))
    end
  end
end
