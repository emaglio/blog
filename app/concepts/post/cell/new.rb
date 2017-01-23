module Post::Cell

  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper

    def current_user
      return options[:context][:current_user]
    end

    def user_name
      return current_user.firstname if current_user.firstname != "" and current_user.firstname != nil

      current_user.email
    end

  end
end