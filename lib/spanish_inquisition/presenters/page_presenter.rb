class SpanishInquisition::Presenters::PagePresenter
  def initialize(form, page)
    @form, @page = form, page
  end

  def to_html
    form.inputs(*input_options) do
      question_presenters.each do |presenter|
        form.template.concat presenter.to_html
      end
    end
  end

  private

  attr_reader :form, :page

  def input_options
    return [] if page.identifier.blank?

    [page.identifier, {id: page.identifier}]
  end

  def question_presenters
    @question_presenters ||= page.questions.collect { |question|
      SpanishInquisition::Presenters::QuestionPresenter.new(form, question)
    }
  end
end
