module User::Cell

  class Show < Trailblazer::Cell 

    property :email
    property :firstname
    property :lastname

    def current_user
      return options[:context][:current_user]
    end

    def edit
      if current_user.email == model.email or current_user.email == "admin@email.com"
        link_to "Edit", edit_user_path(model)
      end
    end

    def delete
      if current_user.email == model.email or current_user.email == "admin@email.com"
        link_to "Delete", user_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}
      end
    end

    def change_password
      if current_user.email == model.email or current_user.email == "admin@email.com"
        link_to "Change Password", get_new_password_users_path
      end
    end


  end
end