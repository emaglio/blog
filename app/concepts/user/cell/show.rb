module User::Cell

  module Policy
    def policy
      context[:policy]
    end
  end

  module Tyrant
    def tyrant
      context[:tyrant]
    end
  end

  class Show < Trailblazer::Cell 
    include Policy
    include Tyrant

    property :email
    property :firstname
    property :lastname


    def edit
      if tyrant.current_user.email == model.email or tyrant.current_user.email == "admin@email.com"
        link_to "Edit", edit_user_path(model)
      end
    end

    def delete
      if tyrant.current_user.email == model.email or tyrant.current_user.email == "admin@email.com"
        link_to "Delete", user_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}
      end
    end

    def change_password
      if tyrant.current_user.email == model.email or tyrant.current_user.email == "admin@email.com"
        link_to "Change Password", get_new_password_users_path
      end
    end

  end
end