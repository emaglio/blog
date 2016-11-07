require 'reform/form/dry'
require 'disposable'

class Post < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Post, :create

    contract do
      include Reform::Form::Dry
      include Property::Hash
      
      property :title
      property :content, field: :hash do
        property :slack do
          property :subtitle
          property :autor
          property :body
        end
      end

      unnet :slack, from: :content


      validation do
       required(:title).filled
       required(:subtitle).filled
       required(:autor).filled
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