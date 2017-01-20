require 'test_helper.rb'

class PostOperationTest < MiniTest::Spec

  let(:admin) {admin_for}


  it "validate correct input" do
    result = Post::Create.({title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever"})
    result.success?.must_equal true
    result["model"].title.must_equal "Test"
    result["model"].subtitle.must_equal "Subtitle"
    result["model"].author.must_equal "Nick"
    result["model"].body.must_equal "whatever"
  end
  
  it "wrong input" do
    result = Post::Create.({})
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:title=>[\"is missing\"], :subtitle=>[\"is missing\"], :author=>[\"is missing\"], :body=>[\"is missing\"]}"
  end


  it "only post owner and admin can modify post" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]
    user2 = User::Create.({email: "user2@email.com", password: "password", confirm_password: "password"})["model"]
    post = Post::Create.({title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever", user_id: user.id})["model"]

    # #user2 trying to modify post
    assert_raises ApplicationController::NotAuthorizedError do
      Post::Update.(
        {id: post.id,
        title: "NewTitle"},
        "current_user" => user2)
    end

    #user can modify post
    result = Post::Update.({id: post.id, title: "newTitle"}, "current_user" => user)
    result.success?.must_equal true
    result["model"].title.must_equal "newTitle"

    #admin can modify post
    result = Post::Update.({id: post.id, title: "adminTitle"}, "current_user" => admin)
    result.success?.must_equal true
    result["model"].title.must_equal "adminTitle"
  end


  it "only post ownner and admin can delete post" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]
    user.email.must_equal "test@email.com"
    user2 = User::Create.({email: "user2@email.com", password: "password", confirm_password: "password"})["model"]
    user2.email.must_equal "user2@email.com"
    post = Post::Create.({title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever", user_id: user.id})
    post.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Post::Delete.(
        {id: post["model"].id},
        "current_user" => user2)
    end

    #successfully deleted by the owner
    result = Post::Delete.({id: post["model"].id}, "current_user" => user)
    result.success?.must_equal true

    post2 = Post::Create.({title: "Test2", subtitle: "Subtitle", author: "Nick", body: "whatever", user_id: user.id})
    post2.success?.must_equal true
    
    #successfully deleted by the admin
    result = Post::Delete.({id: post2["model"].id}, "current_user" => admin)
    result.success?.must_equal true
  end

end 