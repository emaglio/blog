module Post::Lib 
  class Error 
    extend Uber::Callable
    def self.call(options, *)
      options["model"] = Post.new(title: "Post not found!")
      # Trailblazer::Operation::Flow.pass!
    end
  end
end