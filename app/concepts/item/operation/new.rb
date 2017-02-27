require 'reform/form/prepopulate'

class Item::New < Trailblazer::Operation 
  step Model(Item, :new)
  step Contract::Build(constant: Item::Contract::Create)    
end