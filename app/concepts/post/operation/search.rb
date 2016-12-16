class Post < ActiveRecord::Base
  class Search < Trailblazer::Operation
    def model!(params)
      if params[:advance].include? "true"
        advanced_search(params)
      else
        search(params)
      end
    end
  private
    def search(params)
      if params[:keynote] == nil
        Post.all.reverse_order
      else
        Post.where("title like ?", "%"+params[:keynote].to_s+"%")
      end
    end

    def advanced_search(params)
      posts_array = Post.all.reverse_order
      if params[:title] != ""
        posts_array = search_for_title(posts_array, params[:title].to_s)
      end

      if params[:subtitle] != ""
        posts_array = search_for_subtitle(posts_array, params[:subtitle].to_s)
      end
      
      if params[:body] != ""
        posts_array = search_for_body(posts_array, params[:body].to_s)
      end
      
      if params[:author] != ""
        posts_array = search_for_author(posts_array, params[:author].to_s)
      end 
    end

    def search_for_title(model_array, keynote)
      new_array = []
      model_array.each do |model|
        new_array << model if model.title.include? keynote
      end
      return new_array
    end
    
    def search_for_subtitle(model_array, keynote)
      new_array = []
      model_array.each do |model|
        new_array << model if model.content["subtitle"].include? keynote
      end
      return new_array
    end
    
    def search_for_body(model_array, keynote)
      new_array = []
      model_array.each do |model|
        new_array << model if model.content["body"].include? keynote
      end
      return new_array
    end
    
    def search_for_author(model_array, keynote)
      new_array = []
      model_array.each do |model|
        new_array << model if model.content["author"].include? keynote
      end
      return new_array
    end


  end

  class AdvancedSearch < Trailblazer::Operation
  end
end