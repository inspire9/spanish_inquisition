module SpanishInquisition
  def self.load
    return if @loaded

    Dir[Rails.root.join('app', 'surveys', '*.rb')].each do |file|
      ActiveSupport::Dependencies.require_or_load file
    end

    @loaded = true
  end

  def self.surveys
    load
    @surveys ||= {}
  end

  def self.defaults
    @defaults ||= {}
  end

  module Presenters; end
end

require 'spanish_inquisition/attributes'
require 'spanish_inquisition/page'
require 'spanish_inquisition/presenter'
require 'spanish_inquisition/presenters/page_presenter'
require 'spanish_inquisition/presenters/question_presenter'
require 'spanish_inquisition/question'
require 'spanish_inquisition/survey'
require 'spanish_inquisition/survey_not_found'
