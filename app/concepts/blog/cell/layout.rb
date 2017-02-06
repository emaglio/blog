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
      params["action"] == "show" and params["controller"] == "posts"
    end

    def show_id
      return params["id"]
    end
  end
end
