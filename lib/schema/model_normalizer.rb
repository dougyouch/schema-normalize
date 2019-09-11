# frozen_string_literal: true

module Schema
  # Normalize all attributes of a model
  class ModelNormalizer
    def initialize
      @attribute_normalizers = {}
    end

    def add(attribute, method, options = {})
      @attribute_normalizers[attribute] ||= AttributeNormalizer.new
      @attribute_normalizers[attribute].add(method, options)
    end

    def normalize(model)
      @attribute_normalizers.each do |attribute, attribute_normalizer|
        attribute_normalizer.normalize_model_attribute(model, attribute)
      end
      model
    end
  end
end
