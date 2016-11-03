class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render(cell_constant, operation: @operation, model: @operation.model, options: {})
    super(html: cell(cell_constant, model,
      { layout: Blog::Cell::Layout,
        context: { }
      }.merge( options)))   
  end
end
