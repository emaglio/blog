module Blog::Cell
  class Header < Trailblazer::Cell
    def show
      raise model.show_post.inspect
    end
  end
end