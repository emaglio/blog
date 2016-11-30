require 'test_helper.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let!(:user) {(User::Create.(email: "test@email.com", password: "password", confirm_password: "password")).model}
  let!(:user2) {(User::Create.(email: "test2@email.com", password: "password", confirm_password: "password")).model}

  it "validate correct input" do
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.persisted?.must_equal true
    op.model.email.must_equal "test@email.com"
  end

  it "wrong input" do
    res, op = User::Create.run(user: {})
    res.must_equal false
    op.errors.to_s.must_equal "{:email=>[\"is missing\", \"is in invalid format\"], :password=>[\"is missing\"], :confirm_password=>[\"is missing\", \"Passwords are not matching\"]}"
  end

  it "passwords not matching" do
    res,op = User::Create.run(email: "test@email.com", password: "password", confirm_password: "notpassword")
    res.must_equal false
    op.errors.to_s.must_equal "{:confirm_password=>[\"Passwords are not matching\"]}"
  end

  it "only current_user or admin can modify user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises Trailblazer::NotAuthorizedError do
      User::Update.(
        id: user.id,
        email: "newtest@email.com",
        current_user: user2)
    end

    op = User::Update.(id: user.id, email: "newtest@email.com", current_user: user)
    op.model.persisted?.must_equal true
    op.model.email.must_equal "newtest@email.com"
  end

  it "only currebt_user or admin can delete user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises Trailblazer::NotAuthorizedError do
      User::Delete.(
        id: user.id,
        current_user: user2)
    end

    op = User::Delete.(id: user.id, current_user: user)
    op.model.persisted?.must_equal false
  end

  it "reset password" do 
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.persisted?.must_equal true

    User::ResetPassword.(email: op.model.email)

    model = User.find_by(email: op.model.email)

    assert Tyrant::Authenticatable.new(model).digest != "password"
    assert Tyrant::Authenticatable.new(model).digest == "NewPassword"
    Tyrant::Authenticatable.new(model).confirmed?.must_equal true
    Tyrant::Authenticatable.new(model).confirmable?.must_equal false

    Mail::TestMailer.deliveries.length.must_equal 1
    Mail::TestMailer.deliveries.first.to.must_equal ["test@email.com"]
    Mail::TestMailer.deliveries.first.body.raw_source.must_equal "Hi there, here is your temporary password: NewPassword. We suggest you to modify this password ASAP. Cheers" 
  end

  it "wrong input change password" do 
    user = User::Create.(email: "test@email.com", password: "password", confirm_password: "password").model
    user.persisted?.must_equal true

    res, op = User::ChangePassword.run(id: user.id, password: "new_password", new_password: "new_password", confirm_new_password: "wrong_password", current_user: user)
    res.must_equal false

    op.errors.to_s.must_equal "{:password=>[\"Wrong Password\"], :new_password=>[\"New password can't match the old one\"], :confirm_new_password=>[\"New Password are not matching\"]}"
  end

  it "only current_user or admin can change password" do 
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises Trailblazer::NotAuthorizedError do
      User::ChangePassword.(
        id: user.id,
        email: "password",
        new_password: "new_password",
        confirm_new_password: "new_password",
        current_user: user2)
    end

    op = User::ChangePassword.(id: user.id, password: "password", new_password: "new_password", confirm_new_password: "new_password", current_user: user)
    op.model.persisted?.must_equal true

    user_updated = User.find_by(email: user.email)

    assert Tyrant::Authenticatable.new(user_updated).digest != "password"
    assert Tyrant::Authenticatable.new(user_updated).digest == "new_password"
    Tyrant::Authenticatable.new(user_updated).confirmed?.must_equal true
    Tyrant::Authenticatable.new(user_updated).confirmable?.must_equal false    
  end

end