class UsersController < ApplicationController
  
  def show
    run User::Show
    render cell(User::Cell::Show)
  end
  
  def index
    run User::Index
    render cell(User::Cell::Index)
  end

  def create
    run User::Create do |op|
      tyrant.sign_in!(op.model)
      flash[:notice] = "Welcome #{get_name(result["model"])}!"
      return redirect_to "/posts"
    end
    render cell(User::Cell::New, @model)
  end

  def new
    run User::New
    render cell(User::Cell::New, @model)
  end

  def edit
    run User::Update
    render cell(User::Cell::Edit, @model)
  end

  def update
    run User::Update do |op|
      flash[:notice] = "New details saved"
      return redirect_to "/users/#{result["model".id}"
    end
    
    render cell(User::Cell::Edit, @model)
  end

  def destroy
    run User::Delete do |op|
      flash[:alert] = "User deleted"
      return redirect_to "/posts"
    end

    render cell(User::Cell::Edit, @model)
  end

  def reset_password
    run User::ResetPassword do |op| 
      flash[:alert] = "Your password has been reset"
      return redirect_to "/sessions/new"
    end
    render cell(User::Cell::GetEmail)
  end

  def get_email
    run User::GetEmail
    render cell(User::Cell::GetEmail)
  end

  def get_new_password
    run User::GetNewPassword
    render cell(User::Cell::ChangePassword)
  end

  def change_password
    run User::ChangePassword do |op|
      flash[:alert] = "The new password has been saved"
      return redirect_to user_path(tyrant.current_user)
    end

    render cell(User::Cell::ChangePassword)
  end

  def block
    run User::Block do |op|
      if op.model.block == true
        flash[:alert] = "#{get_name(result["model")} has been blocked"
      else
        flash[:alert] = "#{get_name(result["model")} has been un-blocked"
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