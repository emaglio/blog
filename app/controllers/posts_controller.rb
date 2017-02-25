class PostsController < ApplicationController

  def show
    run Post::Show
    render Post::Cell::Show, result["model"]
  end
  
  def index
    run Post::Index
    render Post::Cell::Index, result["model"]
  end

  def create
    run Post::Create do |result|
      flash[:notice] = "#{result["model"].title} has been created and it will be published after the approval by the Administrator. Thank you!"
      return redirect_to "/posts"
    end
    render Post::Cell::New, result["contract.default"]
  end

  def new
    run Post::New
    result["contract.default"].prepopulate!
    render Post::Cell::New, result["contract.default"]
  end

  def edit
    run Post::Edit
    render Post::Cell::Edit, result["model"]
  end

  def update
    run Post::Update do |result|
      flash[:notice] = "#{result["model"].title} has been saved"
      return redirect_to "/posts/#{result["model"].id}"
    end

    render Post::Cell::Edit, result["contract.default"]
  end

  def destroy
    run Post::Delete do
      flash[:alert] = "Post deleted"
      return redirect_to "/posts"
    end

    render Post::Cell::Edit, result["model"]
  end

  def search
    run Post::Search
    render Post::Cell::Index, result["model"]
  end

  def advanced_search
    run Post::AdvancedSearch
    render Post::Cell::AdvancedSearch, result["model"]
  end

  def approve
    run Post::UpdateStatus do |result|
      flash[:alert] = "Post declined!" if result["model"].status == "Declined"
      flash[:notice] = "Post approved!" if result["model"].status == "Approved"
      return redirect_to root_path
    end
    render Post::Cell::Show, result["model"]
  end

end