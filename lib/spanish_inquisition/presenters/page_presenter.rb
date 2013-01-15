class SpanishInquisition::Presenters::PagePresenter
  def initialize(form, page)
    @form, @page = form, page
  end

  def to_html
    form.inputs do
      question_presenters.each do |presenter|
        form.template.concat presenter.to_html
      end
    end
  end

  private

  attr_reader :form, :page

  def question_presenters
    @question_presenters ||= page.questions.collect { |question|
      SpanishInquisition::Presenters::QuestionPresenter.new(form, question)
    }
  end
end
