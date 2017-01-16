class SessionsController < ApplicationController

  def new
    run Session::SignIn
    render cell(Session::Cell::SignIn)
  end

  def create
    run Session::SignIn do |result|
      tyrant.sign_in!(result["model"])
      flash[:notice] = "Hey mate, welcome back!"
      return redirect_to "/posts"
    end
    render cell(Session::Cell::SignIn, @model, current_user: tyrant.current_user)
  end

  def sign_out
    run Session::SignOut do
      tyrant.sign_out!
      flash[:notice] = "See ya!"
      redirect_to "/posts"
    end
  end
end