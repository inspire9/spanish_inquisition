class SpanishInquisition::Page
  attr_reader :questions
  attr_accessor :identifier, :random_order

  def initialize(&block)
    @questions     = []
    @random_order  = false

    block.call self
  end

  def question(identifier = nil, &block)
    identifier ||= "question_#{questions.length}".to_sym
    questions << SpanishInquisition::Question.new(identifier, &block)
  end
end
