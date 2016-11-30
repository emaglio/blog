module User::Cell
  class Show < Trailblazer::Cell 
    property :email
    property :content

    def edit
      if tyrant.current_user.id.to_s == model.content["user_id"] or tyrant.current_user.email == "admin@email.com"
        link_to "Edit", edit_user_path(model)
      end
    end

    def delete
      if tyrant.current_user.id.to_s == model.content["user_id"] or tyrant.current_user.email == "admin@email.com"
        link_to "Delete", user_path(model), method: :delete
      end
    end

    def change_password
      if tyrant.current_user.id.to_s == model.content["user_id"] or tyrant.current_user.email == "admin@email.com"
        link_to "Change Password", get_new_password_users_path
      end
    end
  end
end