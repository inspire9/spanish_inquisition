class SpanishInquisition::Page
  attr_reader :questions

  def initialize(&block)
    @questions = []

    block.call self
  end

  def question(identifier = nil, &block)
    identifier ||= "question_#{questions.length}".to_sym
    questions << SpanishInquisition::Question.new(identifier, &block)
  end
end
