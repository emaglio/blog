module Blog::Cell
  class Layout < Trailblazer::Cell
    include ActionView::Helpers::CsrfHelper
    property :current_user
    property :real_user
    property :signed_in?
  end
end
