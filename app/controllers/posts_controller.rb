class PostsController < ApplicationController
  # protect_from_forgery :except => [:create]

  def show
    present Post::Show
    render Post::Cell::Show
  end
  
  def index
    present Post::Index
    render Post::Cell::Index
  end

  def create
    run Post::Create do |op|
      return redirect_to "/posts"
    end
    render Post::Cell::New, model: @form
  end

  def new
    form Post::Create
    render Post::Cell::New, model: @form
  end

  def destroy
    run Post::Delete do |op|
      return redirect_to "/posts"
    end

    render Post::Cell::Edit, model: @form
  end

end