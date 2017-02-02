module Post::Cell

  class Show < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper
    
    property :title
    property :subtitle
    property :body

    def back
      link_to "Back to posts list", posts_path
    end

    def current_user
      return options[:context][:current_user]
    end

    def edit
      if current_user != nil
        if current_user.id == model.user_id or current_user.email == "admin@email.com" #change in order to have policy
          link_to "Edit", edit_post_path(model.id)
        end
      end
    end

    def delete
      if current_user != nil
        if current_user.id == model.user_id or current_user.email == "admin@email.com" #change in order to have policy
          link_to "Delete", post_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}
        end
      end
    end

    def author
      if model.user_id != nil and current_user != nil and current_user.email == User.find(model.user_id).email
        link_to model.author, user_path(model.user_id)
      else
        return model.author
      end   
    end

    def time
      model.created_at
    end

    def status
      if current_user != nil and current_user.email == "admin@email.com"
        model.status == "Approved" ? (link_to "Decline", post_approve_path(model.id)) : (link_to "Approve", post_approve_path(model.id))
      end
    end

    def admin?
      current_user == nil ? false : current_user.email == "admin@email.com"
    end


  end
end
