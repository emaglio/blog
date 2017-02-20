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

    collection :items, populate_if_empty: Item do
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
  end
end