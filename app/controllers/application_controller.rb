class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper Formular::RailsHelper

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  class NotAuthorizedError < RuntimeError
  end
  
  rescue_from ApplicationController::NotAuthorizedError do |exception|
    flash[:alert] = "You are not authorized mate!"
    redirect_to posts_path
  end

private
  def _run_options(options)
    options.merge("current_user" => tyrant.current_user )
  end
end
