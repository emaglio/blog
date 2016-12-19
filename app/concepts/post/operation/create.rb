require 'reform/form/dry'

class Post < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Post, :create

    contract do
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

    def process(params) 
      validate(params) do
        contract.save
      end
    end 
  end
end
