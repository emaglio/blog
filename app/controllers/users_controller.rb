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
      tyrant.sign_in!(op.model)
      flash[:notice] = "Welcome #{get_name(op.model)}!"
      return redirect_to "/posts"
    end
    render User::Cell::New, model: @form
  end

  def new
    run User::New
    render User::Cell::New, model: @form
  end

  def edit
    form User::Update
    render User::Cell::Edit, model: @form
  end

  def update
    run User::Update do |op|
      flash[:notice] = "New details saved"
      return redirect_to "/users/#{op.model.id}"
    end
    
    render User::Cell::Edit, model: @form
  end

  def destroy
    run User::Delete do |op|
      flash[:alert] = "User deleted"
      return redirect_to "/posts"
    end

    render User::Cell::Edit, model: @form
  end

  def reset_password
    run User::ResetPassword do |op| 
      flash[:alert] = "Your password has been reset"
      return redirect_to "/sessions/new"
    end
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
      flash[:alert] = "The new password has been saved"
      return redirect_to user_path(tyrant.current_user)
    end

    render User::Cell::ChangePassword
  end

  def block
    run User::Block do |op|
      if op.model.block == true
        flash[:alert] = "#{get_name(op.model)} has been blocked"
      else
        flash[:alert] = "#{get_name(op.model)} has been un-blocked"
      end
      redirect_to users_path
    end
  end

private
  def get_name(model)
    name = model.firstname
    if name == nil
      name = model.email
    end
    return name
  end
  
end