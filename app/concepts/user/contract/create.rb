require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'
require "reform/form/coercion"

module User::Contract 
  class Create < Reform::Form 
    feature Reform::Form::Dry
    feature Reform::Form::Coercion
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :firstname
      property :lastname
      property :gender
      property :phone
      property :age
      property :block#, type: Types::Form::Boolean
    end
    
    unnest :firstname, from: :content
    unnest :lastname, from: :content
    unnest :gender, from: :content
    unnest :phone, from: :content
    unnest :age, from: :content
    unnest :block, from: :content
  end
end