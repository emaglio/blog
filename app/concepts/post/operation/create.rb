class Post < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Post, :create

    contract do
      property :title
      property :autor
      property :post

      validates :title, :autor, :post, presence: true
    end

    def process(params)
      validate(params[:post]) do
        contract.save
      end
    end 
  end

end