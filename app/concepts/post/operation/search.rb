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
      condition = ""
      wheres = []
      multiple_condition = false

      if params["title"] != ""
        condition = getConditions("title", condition, multiple_condition)
        wheres << "%" + params["title"].to_s + "%"
        multiple_condition = true
      end

      if params["subtitle"] != ""
        condition = getConditions("subtitle", condition, multiple_condition)
        wheres << "%" + params["subtitle"].to_s + "%"
        multiple_condition = true
      end
      
      if params[:body] != ""
        condition = getConditions("body", condition, multiple_condition)
        wheres << "%" + params["body"].to_s + "%"
        multiple_condition = true
      end
      
      if params[:author] != ""
        condition = getConditions("author", condition, multiple_condition)
        wheres << "%" + params["author"].to_s + "%"
        multiple_condition = true
      end 

      if condition == ""
        return ::Post.all.reverse_order
      else
        wheres.insert(0, condition)
        return Post.where(wheres)
      end
    end

    def getConditions(property, condition, multiple_condition)
      if multiple_condition == true
        condition = condition + " AND "
      end

      condition = condition + property.to_s + " like ?"
      return condition
    end

    def getParams(value, multiple_condition)
      params = ""
      params = "%" + value.to_s + "%"
      return params
    end

    # def search_for_title(model_array, keynote)
    #   new_array = []
    #   model_array.each do |model|
    #     new_array << model if model.title.include? keynote
    #   end
    #   return new_array
    # end
    
    # def search_for_subtitle(model_array, keynote)
    #   new_array = []
    #   model_array.each do |model|
    #     new_array << model if model.content["subtitle"].include? keynote
    #   end
    #   return new_array
    # end
    
    # def search_for_body(model_array, keynote)
    #   new_array = []
    #   model_array.each do |model|
    #     new_array << model if model.content["body"].include? keynote
    #   end
    #   return new_array
    # end
    
    # def search_for_author(model_array, keynote)
    #   new_array = []
    #   model_array.each do |model|
    #     new_array << model if model.content["author"].include? keynote
    #   end
    #   return new_array
    # end


  end

  class AdvancedSearch < Trailblazer::Operation
  end
end