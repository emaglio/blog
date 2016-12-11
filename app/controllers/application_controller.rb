class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render(cell_constant, operation: @operation, model: @operation.model, options: {})
    super(html: cell(cell_constant, model,
      { layout: Blog::Cell::Layout,
        context: {tyrant: tyrant, policy: operation.policy, flash: flash}
      }.merge( options)))   
  end

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  def process_params!(params)
    params.merge!(current_user: tyrant.current_user)
  end

  rescue_from Trailblazer::NotAuthorizedError do |exception|
    redirect_to posts_path
  end

end
