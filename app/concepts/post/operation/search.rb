class Post::Search < Trailblazer::Operation
  step :model!

  def model!(options, params:, **)
    if params[:advance].include? "true"
      result["model"] = advanced_search(params)
    else
      result["model"] = search(params)
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
    date = ""
    new_date = ""
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
      #change date format to have the correct query for SQlite
      #using datetime to use a sencond as sensibility in the search
      date = params["from"]
      new_date = date.slice(6,4) + "-" + date.slice(3,2) + "-" + date.slice(0,2) + " 00:00:00"
      if multiple_condition == true
        condition = condition + " AND "
      end
      
      condition = condition + "datetime(created_at) > ?"
      wheres << new_date
      multiple_condition = true
    end

    if params["to"] != ""
      #change date format to have the correct query for SQlite
      #using datetime to use a sencond as sensibility in the search
      mydate = params["to"]
      new_date = mydate.slice(6,4) + "-" + mydate.slice(3,2) + "-" + mydate.slice(0,2) + " 23:59:59"
      if multiple_condition == true
        condition = condition + " AND "
      end
      
      condition = condition + "datetime(created_at) < ?"
      wheres << new_date
      multiple_condition = true
    end

    if condition == ""
      return ::Post.all.reverse_order
    else
      wheres.insert(0, condition)
      return Post.where(wheres).reverse_order
    end
  end

  def getConditions(property, condition, multiple_condition)
    if multiple_condition == true
      condition = condition + " AND "
    end

    condition = condition + property.to_s + " like ?"
    return condition
  end

  class AdvancedSearch < Trailblazer::Operation
  end
end