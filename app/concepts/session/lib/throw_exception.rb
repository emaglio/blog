module Session::Lib 
  class ThrowException < Trailblazer::Operation
    extend Uber::Callable

    step :exception!

    def exception!(options, *)
      # raise ApplicationController::NotAuthorizedError
    end
  end
end