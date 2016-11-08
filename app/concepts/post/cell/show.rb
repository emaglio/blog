module Post::Cell
  class Show < Trailblazer::Cell
    property :title
    property :content

    def subtitle
      content["subtitle"]
    end
  end
end
