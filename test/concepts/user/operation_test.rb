require 'test_helper.rb'

class UserOperationTest < MiniTest::Spec

  it "validate correct input" do
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.persisted?.must_equal true
    op.model.email.must_equal "test@email.com"
  end

  it "wrong input" do
    res, op = User::Create.run(user: {})
    res.must_equal false
    op.errors.to_s.must_equal "{:email=>[\"is missing\", \"is in invalid format\"], :password=>[\"is missing\"], :confirm_password=>[\"is missing\"]}"
  end

  it "passwords not matching" do
    res,op = User::Create.run(email: "test@email.com", password: "password", confirm_password: "notpassword")
    res.must_equal true
    op.errors.to_s.must_equal "{:must_be_equal=>[\"must be equal to notpassword\"]}"
  end

  it "modify user" do
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.email.must_equal "test@email.com"

    op = User::Update.(id: op.model.id, email: "newtest@email.com", password: "password", confirm_password: "password")
    op.model.persisted?.must_equal true
    op.model.email.must_equal "newtest@email.com"
  end

  it "delete user" do
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.persisted?.must_equal true

    op = User::Delete.(id: op.model.id)
    op.model.persisted?.must_equal false
  end

end