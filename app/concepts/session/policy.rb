class Session::Policy
  
  def initialize(user, model)
    @user = user
    @model = model
  end

  def create?
    true
  end
  
  def current_user?
    raise
    return unless @user
    @user.email == @model.email
  end

end