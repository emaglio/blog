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
    run User::Update do |op|
      return redirect_to "/users/#{op.model.id}"
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
    run User::ResetPassword do |op| 
      return redirect_to "/sessions/new"
    end
    raise
    render User::Cell::GetEmail
  end

  def get_email
    present User::GetEmail
    render User::Cell::GetEmail
  end

  def get_new_password
    present User::GetNewPassword
    render User::Cell::ChangePassword
  end

  def change_password
    run User::ChangePassword do |op|
      return redirect_to user_path(tyrant.current_user)
    end

    render User::Cell::ChangePassword
  end
  
end