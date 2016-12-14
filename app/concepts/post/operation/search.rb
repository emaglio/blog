class Post < ActiveRecord::Base
  class Search < Trailblazer::Operation

    def model!(params)
      return ::Pob.all.reverse_order if params[:keyword] == ""
      ::Post.where("title LIKE ?", params[:keynote])
    end
  
  end
end