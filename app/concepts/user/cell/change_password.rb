module User::Cell

  module Tyrant
    def tyrant
      context[:tyrant]
    end
  end

  class ChangePassword < New
    include Tyrant

    def back
      link_to "Back", user_path(tyrant.current_user)  
    end
  end
end