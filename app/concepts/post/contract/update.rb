require 'reform/form/dry'

module Post::Contract 
  class Update < Reform::Form 
    feature Reform::Form::Dry

    property :title
    property :subtitle
    property :author
    property :body
    property :user_id

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