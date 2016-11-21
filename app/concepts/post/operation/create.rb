require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

class Post < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Post, :create

    contract do
      feature Reform::Form::Dry
      include Disposable::Twin::Property::Hash
      
      property :title
      property :content, field: :hash do
        property :subtitle
        property :author
        property :body
        property :user_id

        validation do
          configure do
            config.messages_file = 'config/error_messages.yml'
          end
          
          required(:subtitle).filled
          required(:author).filled
          required(:body).filled
        end
      end

      unnest :subtitle, from: :content
      unnest :author, from: :content
      unnest :body, from: :content
      unnest :user_id, from: :content

      validation do
        required(:title).filled
      end
    end

    def process(params) 
      validate(params) do
        contract.save
      end
    end 
  end
end
