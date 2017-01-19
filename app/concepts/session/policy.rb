class Session::Policy
  
  def initialize(user, model)
    @user = user
    @model = model
  end

  def true?
    true
  end

  def post_owner?
    return unless @user
    @user.id == @model.user_id
  end

  def admin?
    return unless @user
    @user.email == "admin@email.com"
  end

  def update_delete_post?
    post_owner? or admin?
  end

  def current_user?
    puts @user.inspect
    puts @model.inspect
    return unless @user
    @user.email == @model.email
  end

  def show_block_user?
    current_user? or admin?
  end
end