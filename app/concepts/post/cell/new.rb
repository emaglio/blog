module Post::Cell

  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper

    def user_name
      @name = options["current_user"].firstname

      if @name == nil
        @name = options["current_user"].email
      end
      return @name
    end

    def current_user
      return options["current_user"]
    end
  end
end