require 'date'

class SpanishInquisition::Attributes
  def initialize(values, types)
    @values = translate values, types
  end

  def [](key)
    @values[key]
  end

  def to_hash
    @values
  end

  private

  def translate(values, types)
    types.keys.inject({}) do |hash, key|
      case types[key]
      when :date
        hash[key] = translate_date key, values
      when :location
        hash[key]      = values[key]
        hash[:lat]     = values[:lat]
        hash[:lng]     = values[:lng]
        hash[:state]   = values[:state]
        hash[:country] = values[:country]
      else
        hash[key] = values[key]
      end

      hash
    end
  end

  def translate_date(key, values)
    case values[key]
    when String
      Date.parse values[key]
    when NilClass
      parts = ["#{key}(1i)".to_sym, "#{key}(2i)".to_sym, "#{key}(3i)".to_sym]

      unless parts.any? { |part| values[part].nil? || values[part].empty? }
        Date.new *parts.collect { |part| values[part].to_i }
      end
    else
      values[key]
    end
  end
end
