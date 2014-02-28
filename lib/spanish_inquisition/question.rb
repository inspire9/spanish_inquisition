class SpanishInquisition::Question
  attr_reader   :identifier
  attr_accessor :text, :style, :answers, :capture, :required, :placeholder

  alias_method :required?, :required

  def initialize(identifier, &block)
    @identifier = identifier
    @required   = true

    block.call self
  end

  def capture?(responses)
    @capture.nil? || @capture.call(responses)
  end

  def type
    return :date     if style == :date_select
    return :location if style == :location

    :string
  end
end
