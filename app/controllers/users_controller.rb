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
    run User::Create do |op|
      return redirect_to "/posts"
    end
    render User::Cell::New, model: @form
  end

  def new
    form User::Create
    render User::Cell::New, model: @form
  end

  def edit
    form User::Update
    render User::Cell::Edit, model: @form
  end

  def update
    form User::Update do |op|
      redirect_to user_path(op.model)
    end
    
    render User::Cell::Edit, model: @form
  end

  def destroy
    run User::Delete do |op|
      return redirect_to "/posts"
    end

    render User::Cell::Edit, model: @form
  end

  def reset_password
    run User::ResetPassword do
      redirect_to "session/new"
    end

    render User::Cell::GetEmail
  end

  def get_email
    present User::GetEmail
    render User::Cell::GetEmail
  end
  
end