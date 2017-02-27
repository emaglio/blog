require 'reform/form/dry'

module Item::Contract 
  class Create < Reform::Form 
    feature Reform::Form::Dry
    
    property :position
    property :body
    property :subtitle
    property :type

    validation do
      required(:position).maybe(:int?)
    end
  end
end