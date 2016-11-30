class Session::Policy
  
  def initialize(user, model)
    @user = user
    @model = model
  end

  def post_owner?
    return unless @user
    @user.id.to_s == @model.content["user_id"]
  end

  def admin?
    return unless @user
    @user.email == "admin@email.com"
  end

  def update_delete_post?
    post_owner? or admin?
  end

  def current_user?
    return unless @user
    @user.email == @model.email
  end

  def update_delete_user?
    current_user? or admin?
  end




end