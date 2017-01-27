class UsersController < ApplicationController
  
  def show
    run User::Show
    render User::Cell::Show, result["model"]
  end
  
  def index
    run User::Index
    render User::Cell::Index, result["model"]
  end

  def create
    run User::Create do |result|
      tyrant.sign_in!(result["model"])
      flash[:notice] = "Welcome #{get_name(result["model"])}!"
      return redirect_to "/posts"
    end
    render User::Cell::New, result["contract.default"]
  end

  def new
    run User::New
    render User::Cell::New, result["contract.default"]
  end

  def edit
    run User::Edit
    render User::Cell::Edit, result["model"]
  end

  def update
    run User::Update do |result|
      flash[:notice] = "New details saved"
      return redirect_to "/users/#{result["model"].id}"
    end
    
    render User::Cell::Edit, result["model"]
  end

  def destroy
    run User::Delete do
      flash[:alert] = "User deleted"
      return redirect_to "/posts"
    end

    render User::Cell::Edit, result["contract.default"]
  end

  def reset_password
    run User::ResetPassword do 
      flash[:alert] = "Your password has been reset"
      return redirect_to "/sessions/new"
    end
    render User::Cell::GetEmail, result["contract.default"]
  end

  def get_email
    run User::GetEmail
    render User::Cell::GetEmail, result["contract.default"]
  end

  def get_new_password
    run User::GetNewPassword
    render User::Cell::ChangePassword, result["contract.default"]
  end

  def change_password
    run User::ChangePassword do
      flash[:alert] = "The new password has been saved"
      return redirect_to user_path(tyrant.current_user)
    end

    render User::Cell::ChangePassword, result["contract.default"]
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