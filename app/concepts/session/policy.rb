class Session::Policy
  
  def initialize(user, model)
    @user = user
    @model = model
  end

  def create?
    true
  end

end