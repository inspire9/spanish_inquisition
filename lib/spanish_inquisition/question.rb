class SpanishInquisition::Question
  attr_reader   :identifier
  attr_accessor :text, :style, :answers, :capture, :required, :placeholder, :wrapper_html, :error_subject

  alias_method :required?, :required

  def initialize(identifier, &block)
    @identifier         = identifier
    @required           = true
    @error_subject      = :identifier

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

  def error_subject
    case @error_subject
    when :identifier
      identifier
    when :text
      text
    else
      @error_subject
    end
  end
end
