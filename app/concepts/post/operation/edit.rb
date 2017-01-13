class Post::Edit < Trailblazer::Operation 
  step Model(Post, :find_by)
  step Policy::Pundit( ::Session::Policy, :update_delete_post? )
  failure ExceptionThrower
  step Contract::Build(constant: Post::Create)
end