class SpanishInquisition::Question
  attr_reader   :identifier
  attr_accessor :text, :style, :answers, :capture, :required

  alias_method :required?, :required

  def initialize(identifier, &block)
    @identifier = identifier
    @required   = true

    block.call self
  end

  def capture?(responses)
    @capture.nil? || @capture.call(responses)
  end
end
