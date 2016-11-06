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
    op.errors.to_s.must_equal "{:email=>[\"is missing\", \"is in invalid format\"]}"
  end

  # it "passwords not matching" do
  #   res,op = User::Create.run(email: "test@email.com", password: "password", confirm_password: "notpassword")
  #   res.must_equal false
  #   op.errors.to_s.must_equal "{}"
  # end

  it "modify post" do
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.email.must_equal "test@email.com"

    op = User::Update.(id: op.model.id, email: "newtest@email.com")
    op.model.persisted?.must_equal true
    op.model.email.must_equal "newtest@email.com"
  end

  it "delete post" do
    op = User::Create.(email: "test@email.com", password: "password", confirm_password: "password")
    op.model.persisted?.must_equal true

    op = User::Delete.(id: op.model.id)
    op.model.persisted?.must_equal false
  end

end