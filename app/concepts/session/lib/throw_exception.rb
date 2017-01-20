module Session::Lib 
  class ThrowException 
    extend Uber::Callable
    def self.call(options, *)
      raise ApplicationController::NotAuthorizedError
    end
  end
end 