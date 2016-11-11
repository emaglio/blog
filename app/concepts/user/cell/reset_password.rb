module User::Cell
  class ResetPassword
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper
  end
end