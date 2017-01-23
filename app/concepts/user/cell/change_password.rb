module User::Cell

  class ChangePassword < New

    def back
      link_to "Back", user_path(current_user)
    end

  end
end