module Post::Cell

  class Row < Trailblazer::Cell

    def item

    end

    def type
      options[:type]
    end

    def label
      #maybe add number after subtitle just for the label getting from the position
      labels = {
        :subtitle => "Subtitle 2",
        :body => "Body"
      }

      labels[options[:type]]
    end
  end

end