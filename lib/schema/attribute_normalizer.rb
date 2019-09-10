# frozen_string_literal: true

module Schema
  class AttributeNormalizer
    def initialize
      @normalizations = []
    end

    def normalize_model_attribute(model, field)
      value = model.send(field)
    end

    def normalize(model, value)
      return nil if value.nil?

      @normalizations.each do |normalization|
        value = apply_normalization(model, value, normalization)
      end
      value
    end

    private

    def apply_normalization(model, value, normalization)
      return value if skip_normalization?(model, normalization)

      if normalization[:with]
        if normalization[:class_name] || normalization[:class]
          kls = normalization[:class] || Object.const_get(normalization[:class_name])
          arguments = [value]
          arguments += normalization[:args] if normalization[:args]
          call_method(kls, normalization[:method], arguments)
        else
          call_method(model, normalization[:method], [value])
        end
      else
        call_method(value, normalization[:method], normalization[:args])
      end
    end
    
    def skip_normalization?(model, options)
      return true if options[:if] && !call_method(model, options[:if])
      return true if options[:unless] && call_method(model, options[:unless])
      
      false
    end

    def call_method(object, method, method_arguments = nil)
      case method
      when Symbol
        object.public_send(method, *method_arguments)
      when Proc
        object.instance_eval(&method)
      else
        raise("wrong type, failed to call method #{method}")
      end
    end
  end
end
