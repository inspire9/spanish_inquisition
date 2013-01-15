class SpanishInquisition::Presenters::QuestionPresenter
  def initialize(form, question)
    @form, @question = form, question
  end

  def to_html
    case question.style
    when :one
      form.input question.identifier, as: :radio, collection: question.answers, label: question.text
    when :string
      form.input question.identifier, as: :string, label: question.text
    when :text
      form.input question.identifier, as: :text, label: question.text
    else
      raise "Unknown question style: #{question.style}"
    end
  end

  def to_json(responses = [])
    {
      'identifier' => question.identifier,
      'text'       => question.text,
      'required'   => question.required,
      'capture'    => question.capture?(responses)
    }
  end

  private

  attr_reader :form, :question
end
