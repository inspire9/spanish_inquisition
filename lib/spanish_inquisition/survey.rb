class SpanishInquisition::Survey
  attr_reader   :identifier, :pages
  attr_accessor :heading, :description

  def initialize(identifier, &block)
    @identifier = identifier
    @pages      = []

    block.call self if block

    SpanishInquisition.surveys[identifier] = self
  end

  def duplicate_to(identifier)
    duplicate = self.class.new(identifier)

    duplicate.pages.replace pages.dup
    duplicate.heading     = heading.dup
    duplicate.description = description.dup

    duplicate
  end

  def page(&block)
    pages << SpanishInquisition::Page.new(&block)
  end

  def question_identifiers
    @question_identifiers ||= pages.collect(&:questions).flatten.
      collect(&:identifier)
  end
end
