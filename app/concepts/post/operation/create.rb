require 'reform/form/dry'

class Post < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Post, :create

    contract do
      include Reform::Form::Dry
      
      property :title
      property :subtitle
      property :autor
      property :body

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