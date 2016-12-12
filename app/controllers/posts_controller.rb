class PostsController < ApplicationController

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
      flash[:notice] = "#{op.model.title} has been created"
      return redirect_to "/posts"
    end
    render Post::Cell::New, model: @form
  end

  def new
    form Post::Create
    render Post::Cell::New, model: @form
  end

  def edit
    form Post::Update
    render Post::Cell::Edit, model: @form
  end

  def update
    run Post::Update do |op|
      flash[:notice] = "#{op.model.title} has been saved"
      return redirect_to "/posts/#{op.model.id}"
    end

    render Post::Cell::Edit, model: @form
  end

  def destroy
    run Post::Delete do |op|
      flash[:alert] = "Post deleted"
      return redirect_to "/posts"
    end

    render Post::Cell::Edit, model: @form
  end

end