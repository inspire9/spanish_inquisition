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
        parts = ["#{key}(1i)".to_sym, "#{key}(2i)".to_sym, "#{key}(3i)".to_sym]

        hash[key] = Date.new(
          *parts.collect { |part| values[part].to_i }
        ) unless parts.any? { |part| values[part].nil? || values[part].empty? }
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
end
