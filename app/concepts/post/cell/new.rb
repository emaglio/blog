module Post::Cell

  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::JavaScriptHelper
    include Formular::RailsHelper
    include Formular::Helper

    inherit_views Post::Cell::Row

    def add_row
      render :row
    end

    def current_user
      return options[:context][:current_user]
    end

    def user_name
      current_user.firstname.blank? ? current_user.email : current_user.firstname
    end

    def append
      %{ $("#next").replaceWith("#{j(add_row)}") }
    end

  end
end