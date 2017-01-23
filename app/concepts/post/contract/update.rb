module Post::Contract 
  class Update < Reform::Form 
    
    property :title
    property :subtitle
    property :author
    property :body
    property :user_id

  end
end