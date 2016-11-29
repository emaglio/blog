require 'test_helper.rb'

class PostOperationTest < MiniTest::Spec

  let(:admin) {admin_for}

  it "validate correct input" do
    op = Post::Create.(title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever")
    op.model.persisted?.must_equal true
    op.model.title.must_equal "Test"
    op.model.content.must_equal({"subtitle"=>"Subtitle", "author"=>"Nick", "body"=>"whatever"})
  end

  it "wrong input" do
    res, op = Post::Create.run(post: {})
    res.must_equal false
    op.errors.to_s.must_equal "{:title=>[\"is missing\"], :\"content.subtitle\"=>[\"is missing\"], :\"content.author\"=>[\"is missing\"], :\"content.body\"=>[\"is missing\"]}"
  end


  it "only post owner or can modify post" do
    user = User::Create.(email: "test@email.com", password: "password", confirm_password: "password").model
    user.persisted?.must_equal true
    user2 = User::Create.(email: "user2@email.com", password: "password", confirm_password: "password").model
    user2.persisted?.must_equal true
    post = Post::Create.(title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever", user_id: "#{user.id}").model
    post.title.must_equal "Test"

    #user2 trying to modify post
    assert_raises Trailblazer::NotAuthorizedError do
      Post::Update.(
        id: post.id,
        title: "NewTitle",
        current_user: user2)
    end

    #user can modify post
    op = Post::Update.(id: post.id, title: "newTitle", current_user: user)
    op.model.persisted?.must_equal true
    op.model.title.must_equal "newTitle"

    #admin can modify post
    op = Post::Update.(id: post.id, title: "adminTitle", current_user: admin)
    op.model.persisted?.must_equal true
    op.model.title.must_equal "adminTitle"
  end


  it "only post ownner and admin can delete post" do
    user = User::Create.(email: "test@email.com", password: "password", confirm_password: "password").model
    user.persisted?.must_equal true
    user2 = User::Create.(email: "user2@email.com", password: "password", confirm_password: "password").model
    user2.persisted?.must_equal true
    post = Post::Create.(title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever", user_id: "#{user.id}").model
    post.persisted?.must_equal true

    assert_raises Trailblazer::NotAuthorizedError do
      Post::Delete.(
        id: post.id,
        current_user: user2)
    end


    op = Post::Delete.(id: post.id, current_user: user)
    op.model.persisted?.must_equal false

    post2 = Post::Create.(title: "Test2", subtitle: "Subtitle", author: "Nick", body: "whatever", user_id: "#{user.id}").model
    post.persisted?.must_equal true

    op = Post::Delete.(id: post2.id, current_user: admin)
    op.model.persisted?.must_equal false
  end

end 