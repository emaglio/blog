require 'test_helper.rb'

class NestedFormTest < MiniTest::Spec

  it "nested" do
    params = {post: {id: 1, title: "test2", items_attributes:[{position: 1, body: "body"}]}} 

    post = Post::Create.({title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever", :items => [{position: 1, body: "body"},{position: 2, body: "body2"}]})

    post.success?.must_equal true
    post["model"]["content"].size.must_equal 2
    post["model"]["content"].first.position.must_equal 1
    post["model"]["content"].first.body.must_equal "body"
    post["model"]["content"].last.position.must_equal 2
    post["model"]["content"].last.body.must_equal "body2"
  end
end