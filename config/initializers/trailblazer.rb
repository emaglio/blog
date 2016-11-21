require "trailblazer/operation/dispatch"
# require "trailblazer/operation/representer"
# require "trailblazer/operation/responder"

Trailblazer::Operation.class_eval do
  include Trailblazer::Operation::Dispatch
  include Trailblazer::Operation::Policy
end

Trailblazer::Cell.class_eval do
  def policy
    context[:policy]
  end
end

require_dependency "session/policy"