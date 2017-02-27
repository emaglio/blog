class ItemsController < ApplicationController

  def new
    run Item::New

    render js:
      concept("post/cell/row", result["contract.default"]).(:append)
  end

end