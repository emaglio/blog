module Blog::Cell
  class Layout < Trailblazer::Cell
    property :current_user
    property :real_user
    property :signed_in?

  private      
    def tyrant
      context[:tyrant]
    end
  end
end
