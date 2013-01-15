require 'active_model/naming'
require 'active_model/conversion'
require 'active_model/validations'

class SpanishInquisition::Presenter
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validate :required_answers

  delegate :heading, :description, to: :survey

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Survey')
  end

  def initialize(identifier, attributes = {})
    @survey     = SpanishInquisition.surveys[identifier]
    @attributes = attributes || {}

    raise SpanishInquisition::SurveyNotFound if @survey.nil?
  end

  def answers
    questions.inject({}) do |hash, question|
      if question.capture?(attributes)
        hash[question.identifier] = attributes[question.identifier]
      end

      hash
    end
  end

  def id
    survey.identifier
  end

  def persisted?
    true
  end

  def render_to(form)
    survey.pages.collect { |page|
      SpanishInquisition::Presenters::PagePresenter.new(form, page).to_html
    }.join.html_safe
  end

  def to_json
    questions.collect { |question|
      SpanishInquisition::Presenters::QuestionPresenter.new(nil, question).to_json(attributes)
    }
  end

  private

  attr_reader :survey, :attributes

  def invalid_question?(question)
    question.capture?(attributes) &&
    question.required? &&
    attributes[question.identifier].blank?
  end

  def method_missing(method, *arguments, &block)
    return attributes[method] if survey.question_identifiers.include?(method)

    super
  end

  def questions
    @questions ||= survey.pages.collect(&:questions).flatten
  end

  def required_answers
    questions.each do |question|
      next unless invalid_question?(question)

      errors.add question.identifier, 'must be answered'
    end
  end
end
