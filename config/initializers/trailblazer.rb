require "trailblazer/operation/dispatch"
# require "trailblazer/operation/representer"
# require "trailblazer/operation/responder"

Trailblazer::Operation.class_eval do
  include Trailblazer::Operation::Dispatch
  include Trailblazer::Operation::Policy
end

require_dependency "session/policy"

Trailblazer::NotAuthorizedError.class_eval do # this will extend the existing class, aka "monkey-patching"
    
  attr_reader :query, :record, :policy

  def initialize(options = {})
    if options.is_a? String
      message = options
    else
      @query  = options[:query]
      @record = options[:record]
      @policy = options[:policy]

      message = options.fetch(:message) { "not allowed to #{query} this #{record.inspect}" }
    end
  
    super(message)
  end
end