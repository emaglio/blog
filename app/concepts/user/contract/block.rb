require 'reform/form/dry'

module User::Contract 
  class Block < Reform::Form 
    feature Reform::Form::Dry

    property :block, virtual: true
    
    validation do
      required(:block).filled
    end
  end
end