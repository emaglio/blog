require 'test_helper.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let(:user) {(User::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:user2) {(User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"}))["model"]}

  it "validate correct input" do
    result = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    result.success?.must_equal true
    result["model"].email.must_equal "test@email.com"
  end

  it "wrong input" do
    res, op = User::Create.({})
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"is missing\", \"Wrong format\"], :password=>[\"is missing\"], :confirm_password=>[\"is missing\"]}"
  end

  it "passwords not matching" do
    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "notpassword"})
    res.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:confirm_password=>[\"Passwords are not matching\"]}"
  end

  it "unique user" do
    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    res.success?.must_equal true
    res["model"].email.must_equal "test@email.com"


    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "notpassword"})
    res.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:confirm_password=>[\"Passwords are not matching\"]}"
  end

  it "only current_user can modify user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    # assert_raises Trailblazer::NotAuthorizedError do
    #   User::Update.(
    #     id: user.id,
    #     email: "newtest@email.com",
    #     current_user: user2)
    # end

    res = User::Update.({id: user.id, email: "newtest@email.com"}, "current_user" => user)
    res.success?.must_equal true
    res["model"].email.must_equal "newtest@email.com"
  end

  it "only current_user can delete user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    # assert_raises Trailblazer::NotAuthorizedError do
    #   User::Delete.(
    #     id: user.id,
    #     current_user: user2)
    # end

    res = User::Delete.({id: user.id}, "current_user" => user)
    res.success?.must_equal false
  end

  it "reset password" do 
    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    res.success?.must_equal true

    User::ResetPassword.({email: res["model"].email})

    user = User.find_by(email: res["model"].email)

    assert Tyrant::Authenticatable.new(user["model"]).digest != "password"
    assert Tyrant::Authenticatable.new(user["model"]).digest == "NewPassword"
    Tyrant::Authenticatable.new(user["model"]).confirmed?.must_equal true
    Tyrant::Authenticatable.new(user["model"]).confirmable?.must_equal false

    Mail::TestMailer.deliveries.last.to.must_equal ["test@email.com"]
    Mail::TestMailer.deliveries.last.body.raw_source.must_equal "Hi there, here is your temporary password: NewPassword. We suggest you to modify this password ASAP. Cheers" 
  end

  it "wrong input change password" do 
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    res = User::ChangePassword.({id: user["model"].id, password: "new_password", new_password: "new_password", confirm_new_password: "wrong_password"}, "current_user" => user)
    res.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:password=>[\"Wrong Password\"], :new_password=>[\"New password can't match the old one\"], :confirm_new_password=>[\"New Password are not matching\"]}"
  end

  it "only current_user can change password" do 
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    # assert_raises Trailblazer::NotAuthorizedError do
    #   User::ChangePassword.(
    #     id: user.id,
    #     email: "password",
    #     new_password: "new_password",
    #     confirm_new_password: "new_password",
    #     current_user: user2)
    # end

    op = User::ChangePassword.({id: user.id, password: "password", new_password: "new_password", confirm_new_password: "new_password"}, "current_user" => user)
    op.success?.must_equal true

    user_updated = User.find_by(email: user.email)

    assert Tyrant::Authenticatable.new(user_updated["model"]).digest != "password"
    assert Tyrant::Authenticatable.new(user_updated["model"]).digest == "new_password"
    Tyrant::Authenticatable.new(user_updated["model"]).confirmed?.must_equal true
    Tyrant::Authenticatable.new(user_updated["model"]).confirmable?.must_equal false    
  end

  it "only admin can block user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    # assert_raises Trailblazer::NotAuthorizedError do
    #   User::Block.(
    #     id: user.id,
    #     block: "true",
    #     current_user: user2)
    # end

    op = User::Block.({id: user.id, block: "true"}, "current_user" => admin)
    op.success?.must_equal true 
    op["model"].block.must_equal true
  end

end