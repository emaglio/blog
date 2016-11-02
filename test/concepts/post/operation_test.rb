require 'test_helper.rb'

class PostOperationTest < MiniTest::Spec

  it "validate correct input" do
    op = Post::Create.(post: {title: "Test", autor: "Nick", body: "whatever"})
    op.model.persisted?.must_equal true
    op.model.title.must_equal "Test"
    op.model.autor.must_equal "Nick"
    op.model.body.must_equal "whatever"
  end

  it "wrong input" do
    res, op = Post::Create.run(post: {})
    res.must_equal false
    op.errors.to_s.must_equal "{:title=>[\"can't be blank\"], :autor=>[\"can't be blank\"], :body=>[\"can't be blank\"]}"
  end


  it "modify post" do
    op = Post::Create.(post: {title: "Test", autor: "Nick", body: "whatever"})
    op.model.title.must_equal "Test"

    op = Post::Update.(id: op.model.id, post: {title: "newTitle"})
    op.model.persisted?.must_equal true
    op.model.title.must_equal "newTitle"
  end

  it "delete post" do
    op = Post::Create.(post: {title: "Test", autor: "Nick", body: "whatever"})
    op.model.persisted?.must_equal true

    op = Post::Delete.(id: op.model.id)
    op.model.persisted?.must_equal true
  end

end