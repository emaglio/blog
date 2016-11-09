class SessionsController < ApplicationController

  def new
    form Session::SignIn
    render Session::Cell::SignIn
  end

  def create
    run Session::SignIn do |op|
      tyrant.sign_in!(op.model)
      return redirect_to "/posts"
    end
    render Session::Cell:SignIn, model: @form
  end

  def sing_out
    run Session::SignOut do
      tyrant.sign_out!
      redirect_to "/posts"
    end
  end
end