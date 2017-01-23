module Blog::Cell

  class Layout < Trailblazer::Cell
    include ActionView::Helpers::CsrfHelper
    property :current_user
    property :real_user
    property :signed_in?

    def is_number? string
      true if Float(string) rescue false
    end

    def show_post
      path = request.path
      if path[0..6] == "/posts/" and is_number?(path[-1])
        return true
      end
    end

    def show_id
      return request.path[-1]
    end
  end
end
