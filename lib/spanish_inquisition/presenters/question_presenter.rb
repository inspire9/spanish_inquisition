class SpanishInquisition::Presenters::QuestionPresenter
  def initialize(form, question)
    @form, @question = form, question
  end

  def to_html
    case question.style
    when :one
      form.input question.identifier, as: :radio, collection: question.answers, label: question.text
    when :many
      form.input question.identifier, as: :check_boxes, collection: question.answers, label: question.text
    when :file
      form.input question.identifier, as: :file, label: question.text
    when :password
      form.input question.identifier, as: :password, label: question.text
    when :date_select
      form.input question.identifier, as: :date_select, label: question.text
    when :datetime_select
      form.input question.identifier, as: :datetime_select, label: question.text
    when :time_select
      form.input question.identifier, as: :time_select, label: question.text
    when :string
      form.input question.identifier, as: :string, label: question.text
    when :text
      form.input question.identifier, as: :text, label: question.text
    when :location
      [
        form.input(question.identifier, as: :string, label: question.text, input_html: { class: 'location' }),
        form.input(:lat, as: :hidden, input_html: {class: 'lat'}),
        form.input(:lng, as: :hidden, input_html: {class: 'lng'}),
        form.input(:state, as: :hidden, input_html: {class: 'state'}),
        form.input(:country, as: :hidden, input_html: {class: 'country'})
      ].join(' ').html_safe
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
