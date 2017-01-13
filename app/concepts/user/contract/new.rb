require 'reform/form/dry'

module User::Contract 
  class New < Reform::Form 
    feature Reform::Form::Dry

    property :firstname
    property :lastname
    property :gender
    property :phone
    property :age
    property :block
  end
end