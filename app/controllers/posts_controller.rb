class PostsController < ApplicationController

  def show
    run Post::Show
    render cell(Post::Cell::Show, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end
  
  def index
    run Post::Index
    render cell(Post::Cell::Index, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def create
    run Post::Create do |result|
      flash[:notice] = "#{result["model"].title} has been created"
      return redirect_to "/posts"
    end
    render cell(Post::Cell::New, result["form"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def new
    run Post::New
    render cell(Post::Cell::New, result["form"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def edit
    run Post::Edit
    render cell(Post::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def update
    run Post::Update do |result|
      flash[:notice] = "#{result["model"].title} has been saved"
      return redirect_to "/posts/#{result["model"].id}"
    end

    render cell(Post::Cell::Edit, result["form"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def destroy
    run Post::Delete do
      flash[:alert] = "Post deleted"
      return redirect_to "/posts"
    end

    render cell(Post::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def search
    run Post::Search
    render cell(Post::Cell::Index, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def advanced_search
    run Post::AdvancedSearch
    render cell(Post::Cell::AdvancedSearch, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

end