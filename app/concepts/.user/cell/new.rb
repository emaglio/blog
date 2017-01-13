module User::Cell

  module Tyrant
    def tyrant
      context[:tyrant]
    end  
  end 

  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper
    include Tyrant
  end
end