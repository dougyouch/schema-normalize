# frozen_string_literal: true

module Schema
  module Normalize
    def self.included(base)
      base.extend InheritanceHelper::Methods
      base.extend ClassMethods
    end

    module ClassMethods
      def schema_normalizations
        [].freeze
      end

      def create_schema_model_normalizer
        normalizer = ::Schema::ModelNormalizer.new
        schema_normalizations.each do |(attribute_name, method_name, options)|
          normalizer.add(attribute_name, method_name, options)
        end
        normalizer
      end

      def schema_model_normalizer
        @schema_model_normalizer ||= create_schema_model_normalizer
      end

      def normalize(attribute_name, method_name = nil, options = {}, &block)
        new_value = schema_normalizations.dup << [attribute_name, method_name || block, options]
        redefine_class_method(:schema_normalizations, new_value)
      end
    end

    def normalize
      self.class.schema_model_normalizer.normalize(self)
    end
  end
end
