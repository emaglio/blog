class UsersController < ApplicationController
  
  def show
    run User::Show
    render cell(User::Cell::Show, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end
  
  def index
    run User::Index
    render cell(User::Cell::Index, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def create
    run User::Create do |result|
      tyrant.sign_in!(result["model"])
      flash[:notice] = "Welcome #{get_name(result["model"])}!"
      return redirect_to "/posts"
    end
    render cell(User::Cell::New, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def new
    run User::New
    render cell(User::Cell::New, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def edit
    run User::Edit
    render cell(User::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def update
    run User::Update do |op|
      flash[:notice] = "New details saved"
      return redirect_to "/users/#{result["model"].id}"
    end
    
    render cell(User::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def destroy
    run User::Delete do
      flash[:alert] = "User deleted"
      return redirect_to "/posts"
    end

    render cell(User::Cell::Edit, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def reset_password
    run User::ResetPassword do |op| 
      flash[:alert] = "Your password has been reset"
      return redirect_to "/sessions/new"
    end
    render cell(User::Cell::GetEmail, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def get_email
    run User::GetEmail
    render cell(User::Cell::GetEmail, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def get_new_password
    run User::GetNewPassword
    render cell(User::Cell::ChangePassword, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def change_password
    run User::ChangePassword do |op|
      flash[:alert] = "The new password has been saved"
      return redirect_to user_path(tyrant.current_user)
    end

    render cell(User::Cell::GetEmail, result["model"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def block
    run User::Block do |op|
      if op.model.block == true
        flash[:alert] = "#{get_name(result["model"])} has been blocked"
      else
        flash[:alert] = "#{get_name(result["model"])} has been un-blocked"
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