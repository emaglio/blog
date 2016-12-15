class Post < ActiveRecord::Base
  class Search < Trailblazer::Operation

    def model!(params)
      if params[:keynote] == nil
        Post.all.reverse_order
      else
        Post.where("title like ?", "%"+params[:keynote].to_s+"%")
      end
    end
  
  end
end