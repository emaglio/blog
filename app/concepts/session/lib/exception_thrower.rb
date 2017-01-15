module Session::Lib 
  class ExceptionThrower < Trailblazer::Operation
    extend Uber::Callable

    step :exception!

    def exception!(options, *)
      # raise NotAuthorizedError
    end
  end
end