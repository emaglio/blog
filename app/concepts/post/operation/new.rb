class Post::New < Trailblazer::Operation 
  step Model(Post, :new)
  step Contract::Build(constant: Post::Contract::Create)    
end