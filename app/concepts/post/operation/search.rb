class Post < ActiveRecord::Base
  class Search < Trailblazer::Operation

    def model!(params)
      if params[:keynote] == nil
        return ::Post.all.reverse_order 
      else
        model = []
        ::Post.all.each do |post|
          if post.title.to_s.include? params[:keynote]
            model << Post.find(post.id)
          end
        end
        return model
        # return ::Post.where("title like ?", params[:keynote])
      end
    end
  
  end
end