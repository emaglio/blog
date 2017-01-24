module Post::Cell
  class Edit < New

    def back
      link_to "Back", post_path(model.id)
    end 

    def delete
      link_to "Delete Post", post_path(model.id), method: :delete
    end

    #really bad....need to change this
    def user_name_admin
      user = User.find(model.user_id)

      user.firstname.blank? ? user.email : user.firstname
    end

  end
end
