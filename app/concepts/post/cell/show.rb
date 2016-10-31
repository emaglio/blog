module Post::Cell
  class Show < Trailblazer::Cell
    def show
      render :show
    end
  end
end
