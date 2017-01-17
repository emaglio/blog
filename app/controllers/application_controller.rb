class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def render(cell_constant, operation: @result, model: @result["model"], options: {})
  #   super(html: cell(cell_constant, model,
  #     { layout: Blog::Cell::Layout,
  #       context: {tyrant: tyrant, policy: operation.policy, flash: flash}
  #     }.merge( options)))   
  # end

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  # def process_params!(params)
  #   params.merge!(current_user: tyrant.current_user)
  # end

  class NotAuthorizedError < RuntimeError
  end
  
  rescue_from ApplicationController::NotAuthorizedError do |exception|
    flash[:alert] = "You are not authorized mate!"
    redirect_to posts_path
  end
end
