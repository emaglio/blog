class UsersController < ApplicationController
  
  def show
    present User::Show
    render User::Cell::Show
  end
  
  def index
    present User::Index
    render User::Cell::Index
  end

  def create
    run User::WebCreate do |op|
      return redirect_to "/posts"
    end
    render User::Cell::New, model: @form
  end

  def new
    form User::WebCreate
    render User::Cell::New, model: @form
  end

  def destroy
    run User::Delete do |op|
      return redirect_to "/posts"
    end

    render User::Cell::Edit, model: @form
  end
  
end