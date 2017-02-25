require 'reform/form/dry'

module Post::Contract 
  class Create < Reform::Form 
    feature Reform::Form::Dry
    
    property :title
    property :subtitle
    property :author
    property :body
    property :user_id
    property :status
    property :content

    collection :items, prepopulator: :prepopulate_items!,
                       populate_if_empty: ->(*) { Item.new } do
      property :position
      property :body
      property :subtitle
      property :type

      validation do
        required(:position).maybe(:int?)
      end
    end

    validation do
      configure do
        config.messages_file = 'config/error_messages.yml'
      end
      required(:title).filled
      required(:subtitle).filled
      required(:author).filled
      required(:body).filled
    end
  private
    def prepopulate_items!(options)
      if items == nil
        self.items = [Item.new]
      else
        items << Item.new # full Twin::Collection API available.
      end
    end
  end
end