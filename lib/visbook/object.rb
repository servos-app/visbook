module Visbook
  # Base class for typed API response objects
  #
  # Provides typed accessor methods while maintaining hash compatibility
  # for backwards compatibility and easy data exploration.
  #
  # @example Basic usage
  #   company = Visbook::Objects::Company.new(data)
  #   company.id                       # => 123 (typed accessor)
  #   company["name"]                  # => "Hotel Foo" (hash access)
  #   company.dig("address", "city")   # => "Oslo"
  #   company.to_h                     # => {"id" => 123, ...}
  #
  # @example Defining attributes in subclasses
  #   class Company < Visbook::Object
  #     attribute :id
  #     attribute :name
  #     array_attribute :rooms, type: Room
  #   end
  #
  class Object
    include Enumerable

    class << self
      def attribute(name, type: nil, key: nil)
        key ||= camelize(name.to_s)

        attributes[name] = {key: key, type: type}

        define_method(name) do
          value = @data[key]
          return nil if value.nil?

          if type
            @wrapped_values[name] ||= wrap_value(value, type)
          else
            value
          end
        end
      end

      def array_attribute(name, type:, key: nil)
        key ||= camelize(name.to_s)

        attributes[name] = {key: key, type: type, array: true}

        define_method(name) do
          @wrapped_values[name] ||= begin
            raw = @data[key] || []
            raw.map { |item| wrap_value(item, type) }
          end
        end
      end

      def attributes
        @attributes ||= {}
      end

      def construct_from(data)
        return nil if data.nil?
        new(data)
      end

      # Visbook uses camelCase keys; our attribute names are snake_case.
      def camelize(snake)
        head, *tail = snake.split("_")
        ([head] + tail.map(&:capitalize)).join
      end
    end

    def initialize(data)
      @data = data.is_a?(Hash) ? data : {}
      @wrapped_values = {}
    end

    def [](key)
      @data[key.to_s]
    end

    def dig(*keys)
      @data.dig(*keys.map(&:to_s))
    end

    def to_h
      @data.dup
    end
    alias_method :to_hash, :to_h

    def to_json(*args)
      @data.to_json(*args)
    end

    def as_json(*)
      to_h
    end

    def each(&block)
      @data.each(&block)
    end

    def keys
      @data.keys
    end

    def values
      @data.values
    end

    def key?(key)
      @data.key?(key.to_s)
    end
    alias_method :has_key?, :key?

    def fetch(key, *args, &block)
      @data.fetch(key.to_s, *args, &block)
    end

    def inspect
      "#<#{self.class.name} #{@data.inspect}>"
    end

    def to_s
      inspect
    end

    def ==(other)
      case other
      when Visbook::Object
        @data == other.to_h
      when Hash
        @data == other
      else
        false
      end
    end

    private

    def wrap_value(value, type)
      return nil if value.nil?

      if type.respond_to?(:construct_from)
        type.construct_from(value)
      elsif type.is_a?(Class) && type < Visbook::Object
        type.new(value)
      else
        value
      end
    end
  end
end
