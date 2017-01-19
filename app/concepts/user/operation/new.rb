class User::New < Trailblazer::Operation 
  step Model(User, :new)
  step Contract::Build(constant: User::Contract::New)    
end