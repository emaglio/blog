module Blog::Cell

  module Tyrant
    def tyrant
      context[:tyrant]
    end
  end

  class Layout < Trailblazer::Cell
    include Tyrant
    include ActionView::Helpers::CsrfHelper
    property :current_user
    property :real_user
    property :signed_in?
  end
end
