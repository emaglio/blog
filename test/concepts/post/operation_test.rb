require "test_helper.rb"

class PostOperationTest < MiniTest::Spec

  it "validate correct input" do
    op = Post.Create.(title: "Test", autor: "Nick", post: "whatever")
    op.model.persisted?.must_equal true
    op.model.title.must_equal "Test"
    op.model.autor.must_equal "Nick"
    op.model.post.must_equal "whatever"

  end


end