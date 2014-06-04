require 'active_model/naming'
require 'active_model/conversion'
require 'active_model/validations'

class SpanishInquisition::Presenter
  include ActiveModel::Conversion
  include ActiveModel::Validations

  LOCATION_IDENTIFIERS = [:lat, :lng, :state, :country]
  REQUIRED_LOCATION_IDENTIFIERS = [:lat, :lng]

  validate :required_answers

  delegate :heading, :description, to: :survey

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Survey')
  end

  def initialize(identifier, attributes = {})
    @survey     = SpanishInquisition.surveys[identifier]
    @attributes = SpanishInquisition::Attributes.new(
      attributes || {}, question_types
    )

    raise SpanishInquisition::SurveyNotFound if @survey.nil?
  end

  def answers
    questions.inject({}) do |hash, question|
      question_identifiers(question).each do |identifier|
        hash[identifier] = attributes[identifier]
      end if question.capture?(attributes)

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

  def respond_to?(method, include_all = false)
    survey.question_identifiers.include?(method)                  ||
    (LOCATION_IDENTIFIERS.include?(method) && location_question?) ||
    super
  end

  def to_json
    questions.collect { |question|
      SpanishInquisition::Presenters::QuestionPresenter.new(nil, question).to_json(attributes.to_hash)
    }
  end

  private

  attr_reader :survey, :attributes

  def invalid_question?(question)
    question.capture?(attributes) &&
    question.required? &&
    question_identifiers(question, true).any? { |identifier|
      attributes[identifier].blank?
    }
  end

  def location_question?
    survey.pages.collect(&:questions).flatten.any? { |question|
      question.style == :location
    }
  end

  def method_missing(method, *arguments, &block)
    return attributes[method] if survey.question_identifiers.include? method
    if LOCATION_IDENTIFIERS.include?(method) && location_question?
      return attributes[method]
    end

    super
  end

  def questions
    @questions ||= survey.pages.collect(&:questions).flatten
  end

  def question_identifiers(question, required = false)
    return [question.identifier] unless question.style == :location

    if required
      [question.identifier] + REQUIRED_LOCATION_IDENTIFIERS
    else
      [question.identifier] + LOCATION_IDENTIFIERS
    end
  end

  def question_types
    questions.inject({}) do |hash, question|
      hash[question.identifier] = question.type
      hash
    end
  end

  def required_answers
    questions.each do |question|
      next unless invalid_question?(question)

      case question.style
      when :location
        errors.add question.error_subject, 'must be selected from the prompted options'
      else
        errors.add question.error_subject, 'must be answered'
      end
    end
  end
end
