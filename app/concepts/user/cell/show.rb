module User::Cell

  class Show < Trailblazer::Cell 

    property :email
    property :firstname
    property :lastname


    def edit
      if options["current_user"].email == model.email or options["current_user"].email == "admin@email.com"
        link_to "Edit", edit_user_path(model)
      end
    end

    def delete
      if options["current_user"].email == model.email or options["current_user"].email == "admin@email.com"
        link_to "Delete", user_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}
      end
    end

    def change_password
      if options["current_user"].email == model.email or options["current_user"].email == "admin@email.com"
        link_to "Change Password", get_new_password_users_path
      end
    end

    def current_user
      return options["current_user"]
    end

  end
end