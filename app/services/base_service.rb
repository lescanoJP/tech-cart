class BaseService < Patterns::Service
  class_attribute :steps
  attr_reader :errors, :steps

  def initialize(*_args)
    @errors = []
    @failed = false
  end

  def call
    process_steps
  end

  def success?
    !@failed
  end

  def self.steps(*steps)
    self.steps = steps
  end

  def fail(*errors, stop: true)
    @errors ||= []
    @errors.push(*errors&.flatten)
    @failed = true
    raise @errors.to_json if stop
  end

  private

  def process_steps
    self.class.steps.each do |step|
      method(step).call
    end
    nil
  rescue RuntimeError => e
    raise unless @failed
  end

end
