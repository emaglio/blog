module Post::Lib 
  class ExceptionThrower 
    extend Uber::Callable
    def self.call(options, *)
      raise NotAuthorizedError
    end
  end
end