module Post::Cell

  class Row < Trailblazer::Cell
    def nested
      options[:nested_form]
    end

    def type
      options[:type]
    end

    def label
      #maybe add number after subtitle just for the label getting from the position, maybe
      labels = {
        :subtitle => "Subtitle 2",
        :body => "Body"
      }

      labels[options[:type]]
    end

  end

end