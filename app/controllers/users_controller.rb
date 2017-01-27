require_dependency "tyrant/cell/reset_password"
require_dependency "tyrant/cell/change_password"

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
    render cell(User::Cell::New, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def new
    run User::New
    render cell(User::Cell::New, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def edit
    run User::Edit
    render cell(User::Cell::Edit, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def update
    run User::Update do |result|
      flash[:notice] = "New details saved"
      return redirect_to "/users/#{result["model"].id}"
    end
    
    render cell(User::Cell::Edit, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def destroy
    run User::Delete do
      flash[:alert] = "User deleted"
      return redirect_to "/posts"
    end

    render cell(User::Cell::Edit, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def reset_password
    run Tyrant::ResetPassword do 
      flash[:alert] = "Your password has been reset"
      return redirect_to "/sessions/new"
    end
    render cell(Tyrant::Cell::ResetPassword, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def get_email
    run Tyrant::GetEmail
    render cell(Tyrant::Cell::ResetPassword, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def get_new_password
    run Tyrant::GetNewPassword
    render cell(Tyrant::Cell::ChangePassword, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def change_password
    run Tyrant::ChangePassword do
      flash[:alert] = "The new password has been saved"
      return redirect_to user_path(tyrant.current_user)
    end

    render cell(Tyrant::Cell::ChangePassword, result["contract.default"], context: { current_user: tyrant.current_user, flash: flash }, layout: Blog::Cell::Layout)
  end

  def block
    run User::Block do |result|
      if result["model"]["block"] == true
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