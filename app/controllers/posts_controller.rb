class PostsController < ApplicationController

  def show
    run Post::Show, current_user: tyrant.current_user, params: params
    render cell(Post::Cell::Show, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end
  
  def index
    run Post::Index, current_user: tyrant.current_user
    render cell(Post::Cell::Index, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def create
    run Post::Create, current_user: tyrant.current_user do |result|
      flash[:notice] = "#{result["model"].title} has been created"
      return redirect_to "/posts"
    end
    render cell(Post::Cell::New, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def new
    run Post::New, current_user: tyrant.current_user
    render cell(Post::Cell::New, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def edit
    run Post::Edit, current_user: tyrant.current_user
    render cell(Post::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def update
    run Post::Update, current_user: tyrant.current_user do |result|
      flash[:notice] = "#{result["model"].title} has been saved"
      return redirect_to "/posts/#{result["model"].id}"
    end

    render cell(Post::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def destroy
    run Post::Delete, current_user: tyrant.current_user do
      flash[:alert] = "Post deleted"
      return redirect_to "/posts"
    end

    render cell(Post::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def search
    run Post::Search
    render cell(Post::Cell::Index)
  end

  # def advanced_search
  #   run Post::AdvancedSearch
  #   render Post::Cell::AdvancedSearch
  # end

end