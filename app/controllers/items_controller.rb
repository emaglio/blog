class ItemsController < ApplicationController

  def new
    run Item::New

    render js:
      concept("post/cell/new", result["contract.default"]).(:append)
  end

end