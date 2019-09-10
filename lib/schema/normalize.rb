# frozen_string_literal: true

module Schema
  module Normalize
     def self.included(base)
      base.extend InheritanceHelper::Methods
      base.extend ClassMethods
    end

     module ClassMethods
       def normalized_attributes
         {}.freeze
       end

       def normalize(attribute_name, method_name, options = {})
         if method_name.is_a?(Hash)
           options = method_name
           method_name = nil
         end
       end
     end
  end
end
