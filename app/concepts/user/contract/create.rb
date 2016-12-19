require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'
require "reform/form/coercion"

module User::Contract 
  class Create < Reform::Form 
    feature Reform::Form::Dry

    property :firstname
    property :lastname
    property :gender
    property :phone
    property :age
    property :block
  end
end