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
      #not the best but at the end of the day there is just one query to the database
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
      
      if params["body"] != ""
        condition = getConditions("body", condition, multiple_condition)
        wheres << "%" + params["body"].to_s + "%"
        multiple_condition = true
      end
      
      if params["author"] != ""
        condition = getConditions("author", condition, multiple_condition)
        wheres << "%" + params["author"].to_s + "%"
        multiple_condition = true
      end 

      if params["from"] != ""
        if multiple_condition == true
          condition = condition + " AND "
        end
        
        condition = condition + "DATE(created_at) >= ?"
        wheres << params["from"].strftime("%F")
        multiple_condition = true
      end

      if params["to"] != ""
        if multiple_condition == true
          condition = condition + " AND "
        end
        
        condition = condition + "DATE(created_at) <= ?"
        wheres << params["to"].strftime("%F")
        multiple_condition = true
      end

      if condition == ""
        return ::Post.all.reverse_order
      else
        wheres.insert(0, condition)
        raise wheres.inspect
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


  end

  class AdvancedSearch < Trailblazer::Operation
  end
end