class PostsController < ApplicationController

  def show
    render text: cell(Post::Cell::Show, nil, layout: Blog::Cell::Layout)
  end
  
end