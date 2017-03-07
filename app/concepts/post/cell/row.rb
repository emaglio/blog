module Post::Cell

  class Row < Trailblazer::Cell
    include ActionView::Helpers::JavaScriptHelper

    # def show
    #   render :row
    # end

    def item

    end

    def type
      params[:type]
    end

    def label
      #maybe add number after subtitle just for the label getting from the position
      labels = {
        :subtitle => "Subtitle 2",
        :body => "Body"
      }

      labels[params[:type]]
    end

    def append
      %{ $("#next").replaceWith("#{j(show)}") }
    end

    def item
      params[:nested_form]
    end

    def fields
      html = field_id("#{field_name}[id]")
      html += field_hidden("#{field_name}[_destroy]", '0')

      options[:fields].each do |field|
        html += generate(field)
      end

      html
    end

  private

    def generate(field)
      send(
        "field_#{field[:type]}",
        "#{field_name}[#{field[:name]}]",
        field_value(field[:name]),
        field
      )
    end

    def object
      @nested_form.object if @nested_form
    end

    def object_name
      options[:form].object_name
    end

    def field_name
      "#{object_name}[#{options[:attribute_name]}_attributes][]"
    end

    def field_value(name)
      if field_attributes
        field_attributes[name]
      else
        object ? object.send(name) : nil
      end
    end

    def field_attributes
      return unless params.key?(object_name) && @nested_form

      params[object_name][options[:attribute_name]][@nested_form.index]
    end

    def field_id(name)
      if object && object.try(:id)
        @nested_form.hidden_field(:id, name: name)
      else
        hidden_field_tag(name)
      end
    end

    def field_boolean(name, value, options = {})
      label_tag(nil, check_box_tag(name, '1', value) + " #{options[:label]}")
    end

    def field_collection(name, value, options = {})
      select_tag(
        name,
        options_for_select(options[:collection], value),
        class: 'uk-form-width-medium'
      )
    end

    def field_hidden(name, value, _options = {})
      hidden_field_tag(name, value)
    end

    def field_string(name, value, _options = {})
      text_field_tag(name, value, class: 'uk-form-width-medium')
    end

  end
end